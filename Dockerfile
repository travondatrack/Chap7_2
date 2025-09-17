# Multi-stage Dockerfile
# 1) Build the WAR using Maven
FROM maven:3.9-openjdk-11 AS build
WORKDIR /build
COPY pom.xml .
# copy source
COPY src ./src
RUN mvn -B -DskipTests package

# 2) Use Tomcat 9 with OpenJDK 11 to run the WAR
FROM tomcat:9.0-jdk11-openjdk
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Install xmlstarlet for XML manipulation in port configuration
RUN apt-get update && apt-get install -y xmlstarlet && rm -rf /var/lib/apt/lists/*

# Remove default webapps to keep image small
RUN rm -rf $CATALINA_HOME/webapps/*

# Copy WAR from build stage and name as ROOT.war so it's served at '/'
COPY --from=build /build/target/Chap7_2-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/ROOT.war

# Copy entrypoint script that will set Tomcat connector port from $PORT if provided
COPY set_port_and_run.sh /usr/local/bin/set_port_and_run.sh
RUN chmod +x /usr/local/bin/set_port_and_run.sh

# Expose default Tomcat port (can be overridden by setting PORT environment variable at runtime)
EXPOSE 8080

# Run the helper which will adjust server.xml if $PORT is set, then start Tomcat
CMD ["/usr/local/bin/set_port_and_run.sh"]
