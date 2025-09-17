#!/bin/sh
# Replace the Tomcat connector port with the $PORT value if provided
if [ -n "$PORT" ]; then
  echo "Setting Tomcat port to $PORT"
  # Use xmlstarlet if available, otherwise fallback to sed replacement for the Connector port attribute
  if command -v xmlstarlet >/dev/null 2>&1; then
    xmlstarlet ed -L -u "/Server/Service/Connector[@protocol='HTTP/1.1']/@port" -v "$PORT" $CATALINA_HOME/conf/server.xml || true
  else
    # Simple sed: replace port="8080" in the first Connector occurrence
    sed -i "0,/<Connector /s/port=\"[0-9]*\"/port=\"$PORT\"/" $CATALINA_HOME/conf/server.xml || true
  fi
fi

echo "Starting Tomcat..."
exec catalina.sh run
