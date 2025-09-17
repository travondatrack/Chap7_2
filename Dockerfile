# Multi-stage Dockerfile optimized for Render deployment
# 1) Build the WAR using Maven
FROM openjdk:11-jdk-slim AS build

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy POM first for better layer caching
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the WAR file
RUN mvn -B -DskipTests clean package

# 2) Use Tomcat 9 with OpenJDK 11 to run the WAR
FROM tomcat:9.0-jdk11-openjdk-slim
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Install xmlstarlet for XML manipulation in port configuration
RUN apt-get update && \
    apt-get install -y --no-install-recommends xmlstarlet && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Remove default webapps to keep image small
RUN rm -rf $CATALINA_HOME/webapps/*

# Copy WAR from build stage and name as ROOT.war so it's served at '/'
COPY --from=build /build/target/Chap7_2-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war

# Copy entrypoint script that will set Tomcat connector port from $PORT if provided
COPY set_port_and_run.sh /usr/local/bin/set_port_and_run.sh
RUN chmod +x /usr/local/bin/set_port_and_run.sh

# Create non-root user for security
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat $CATALINA_HOME
USER tomcat

# Expose default Tomcat port (can be overridden by setting PORT environment variable at runtime)
EXPOSE 8080

# Health check for Render
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Run the helper which will adjust server.xml if $PORT is set, then start Tomcat
CMD ["/usr/local/bin/set_port_and_run.sh"]
