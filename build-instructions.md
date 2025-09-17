# Build Instructions for Tomcat 9

## Prerequisites

- Java 8 or higher
- Apache Maven 3.x
- Apache Tomcat 9.x
- NetBeans IDE (recommended)

## Changes Made for Tomcat 9 Compatibility

### 1. Updated pom.xml

- Replaced Jakarta EE dependencies with Java EE (javax.\*) dependencies
- Added specific servlet, JSP, and JSTL dependencies
- Updated Maven plugin versions

### 2. Updated web.xml

- Changed namespace from Jakarta EE 4.0 to Java EE 3.0
- Compatible with Servlet API 3.0

### 3. Servlet Configuration

- Uses javax.servlet instead of jakarta.servlet
- Updated @WebServlet annotation format

## Build and Deploy Steps

### Using NetBeans:

1. Open the project in NetBeans IDE
2. Right-click on project → Clean and Build
3. Right-click on project → Run
4. NetBeans will automatically deploy to configured Tomcat server

### Manual Build:

1. Open command prompt in project directory
2. Run: `mvn clean package`
3. Copy the generated .war file from `target/` to Tomcat's `webapps/` folder
4. Start Tomcat server
5. Access: http://localhost:8080/Chap7_2/

## Testing the Application

### Workflow:

1. Visit http://localhost:8080/Chap7_2/
2. Click on any album link
3. If first visit → Registration form appears
4. Fill in registration form and submit
5. Redirected to download page with song list
6. Subsequent clicks on albums → Direct access to download page

### Session Management:

- Session timeout: 30 minutes
- Session stores: user email, first name, last name
- Session automatically managed by Tomcat

## Troubleshooting

### Common Issues:

1. **Compilation errors**: Check Java version compatibility
2. **JSP errors**: Ensure JSP API is included in Tomcat lib
3. **Session issues**: Clear browser cookies and restart Tomcat
4. **Path issues**: Verify servlet mapping in web.xml

### Tomcat Configuration:

- Ensure Tomcat 9.x is properly installed
- Verify JAVA_HOME environment variable
- Check Tomcat logs in `logs/catalina.out` for errors
