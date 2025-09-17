# Deploy to Render

This document provides step-by-step instructions to deploy the Java web application to Render using Docker.

## Prerequisites

- GitHub repository with your code
- Render account (free tier available)

## Deployment Steps

### 1. Push Code to GitHub

Make sure your code is pushed to a GitHub repository with all recent changes.

### 2. Create New Web Service on Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Choose your repository from the list

### 3. Configure Web Service

**Basic Settings:**

- **Name**: `chap7-2-music-app` (or any name you prefer)
- **Region**: Choose closest to your users
- **Branch**: `main` (or your default branch)
- **Runtime**: Docker
- **Build Command**: (leave empty - Docker handles this)
- **Start Command**: (leave empty - Docker handles this)

**Environment Variables:**

- No special environment variables needed (PORT is automatically provided by Render)

**Plan:**

- Choose "Free" for testing (has limitations) or "Starter" for production

### 4. Deploy

1. Click "Create Web Service"
2. Render will automatically:
   - Pull your code from GitHub
   - Build the Docker image
   - Deploy the application
   - Provide a public URL

### 5. Access Your Application

Once deployment is complete (usually 5-10 minutes):

- Your app will be available at: `https://your-service-name.onrender.com`
- Example: `https://chap7-2-music-app.onrender.com`

## Testing the Deployment

1. Visit your Render URL
2. You should see the "List of albums" page
3. Click any album (e.g., "Ai Cũng Phải Bắt Đầu Từ Đâu Đó – HIEUTHUHAI (2023)")
4. Fill in registration form if it's your first visit
5. You should see the download page with MP3 download links
6. Test downloading a "Music.mp3" file

## Application Flow

1. **Home Page**: Lists all available albums
2. **Registration**: First-time visitors register with email/name
3. **Download Page**: Registered users can download Music.mp3 files
4. **Session Management**: Remembers users for future visits

## Technical Details

- **Base URL**: Your app runs at root path `/`
- **Port**: Automatically configured by Render (uses $PORT environment variable)
- **File Storage**: MP3 files are included in the Docker image
- **Session Timeout**: 30 minutes
- **Supported Albums**:
  - HIEUTHUHAI (2023)
  - SZA (2022)
  - Harry Styles (2022)
  - Maroon 5 (2012)

## Troubleshooting

### Build Fails

- Check GitHub repository has all files
- Verify Dockerfile syntax
- Check build logs in Render dashboard

### App Won't Start

- Check startup logs in Render dashboard
- Verify PORT environment variable is being used
- Check if Tomcat is starting properly

### Downloads Don't Work

- Verify Music.mp3 files exist in each album folder
- Check if files are included in Docker image (not excluded by .dockerignore)

### 404 Errors

- Check servlet mappings in web.xml
- Verify WAR file is deployed as ROOT.war
- Check application logs

## Render Free Tier Limitations

- Apps sleep after 15 minutes of inactivity
- Limited bandwidth and compute hours
- Cold start delay when app wakes up

For production use, consider upgrading to a paid plan.

## Support

If you encounter issues:

1. Check Render build and runtime logs
2. Verify all MP3 files are present
3. Test locally with Docker first:
   ```bash
   docker build -t chap7_2 .
   docker run -p 8080:8080 chap7_2
   ```
4. Visit `http://localhost:8080` to test locally
