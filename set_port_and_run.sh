#!/bin/bash
# Script to configure Tomcat port for Render deployment

# Replace the Tomcat connector port with the $PORT value if provided
if [ -n "$PORT" ]; then
  echo "Setting Tomcat port to $PORT for Render deployment"
  
  # Use xmlstarlet if available, otherwise fallback to sed replacement for the Connector port attribute
  if command -v xmlstarlet >/dev/null 2>&1; then
    echo "Using xmlstarlet to update server.xml"
    xmlstarlet ed -L -u "/Server/Service/Connector[@protocol='HTTP/1.1']/@port" -v "$PORT" $CATALINA_HOME/conf/server.xml || {
      echo "xmlstarlet failed, falling back to sed"
      sed -i "0,/<Connector /s/port=\"[0-9]*\"/port=\"$PORT\"/" $CATALINA_HOME/conf/server.xml
    }
  else
    echo "Using sed to update server.xml"
    # Simple sed: replace port="8080" in the first Connector occurrence
    sed -i "0,/<Connector /s/port=\"[0-9]*\"/port=\"$PORT\"/" $CATALINA_HOME/conf/server.xml
  fi
  
  echo "Tomcat configured to run on port $PORT"
  
  # Verify the configuration was applied
  if grep -q "port=\"$PORT\"" $CATALINA_HOME/conf/server.xml; then
    echo "✓ Port configuration successfully applied"
  else
    echo "⚠ Warning: Port configuration may not have been applied correctly"
  fi
else
  echo "No PORT environment variable set, using default Tomcat port 8080"
fi

# Set JVM options for better performance on limited resources (Render free tier)
export JAVA_OPTS="-Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

echo "Starting Tomcat with JAVA_OPTS: $JAVA_OPTS"
echo "Tomcat version: $(catalina.sh version | head -1)"

# Start Tomcat
exec catalina.sh run
