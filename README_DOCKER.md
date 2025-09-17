# Docker build & deploy instructions

This project is a Maven-based Jakarta EE webapp (WAR). The included `Dockerfile` performs a multi-stage build:

- Build stage: uses `maven:3.8.8-openjdk-11` to run `mvn package` and produce `target/Chap7_2-1.0-SNAPSHOT.war`.
- Runtime stage: uses `tomcat:9.0-jdk11-openjdk` and deploys the WAR as `ROOT.war` so the app is served at `/`.

Local build and run (Windows cmd):

```
docker build -t chap7_2:latest .
docker run --rm -p 8080:8080 chap7_2:latest
```

Then open `http://localhost:8080/` in your browser.

Deploying to Render (Docker):

1. Create a new Web Service on Render and choose the "Docker" option.
2. Connect your repository; Render will run `docker build` for you using the repository root Dockerfile.
3. Render provides a `PORT` environment variable to the container. The included entrypoint script will update Tomcat to listen on `$PORT`. No further action required.
4. If you prefer a fixed port, set the service to use `8080` and it will match Tomcat's default.
5. Optionally, if you excluded media files via `.dockerignore`, upload or host your `musicStore` media separately (e.g., an object storage) and update the code to point to those URLs or include them in the image by editing `.dockerignore`.

Notes & tips:

- If you want the MP3 files included in the image, remove the `src/main/webapp/musicStore/sound/*` line from `.dockerignore`.
- Render sets the environment variable `PORT` for the service; Tomcat listens on `8080` by default. If Render requires binding to a different port, you will need to adjust the Tomcat connector configuration or use a small wrapper that reads `$PORT` and rewrites server.xml accordingly.
