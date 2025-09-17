#!/bin/sh
# Replace the Tomcat connector port with the $PORT value if provided
if [ -n "$PORT" ]; then
  echo "Setting Tomcat port to $PORT for Render deployment"
  # Use xmlstarlet if available, otherwise fallback to sed replacement for the Connector port attribute
  if command -v xmlstarlet >/dev/null 2>&1; then
    echo "Using xmlstarlet to update server.xml"
    xmlstarlet ed -L -u "/Server/Service/Connector[@protocol='HTTP/1.1']/@port" -v "$PORT" $CATALINA_HOME/conf/server.xml || true
  else
    echo "Using sed to update server.xml"
    # Simple sed: replace port="8080" in the first Connector occurrence
    sed -i "0,/<Connector /s/port=\"[0-9]*\"/port=\"$PORT\"/" $CATALINA_HOME/conf/server.xml || true
  fi
  echo "Tomcat configured to run on port $PORT"
else
  echo "No PORT environment variable set, using default Tomcat port 8080"
fi

echo "Starting Tomcat..."
exec catalina.sh run
