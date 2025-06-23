# Stage 1: Build the Angular app
# Use the official Node.js 20 image to build the Angular project
FROM node:20 AS build
# Set the working directory inside the container
WORKDIR /app
# Copy only package.json and package-lock.json first for dependency install
COPY package*.json ./
# Install dependencies with legacy peer deps for compatibility
RUN npm install --legacy-peer-deps
# Copy the rest of the application code
COPY . .
# Build the Angular app for production and list the build output for debugging
RUN npm run build --configuration=production && ls -l dist || (echo 'BUILD FAILED' && ls -l dist && cat /app/angular.json && exit 1)
# Add Netlify _redirects file for SPA routing
RUN echo '/*    /index.html   200' > /app/dist/browser/_redirects

# Stage 2: Serve with Nginx
# Use the official Nginx image to serve the built Angular app
FROM nginx:alpine
# Copy the Angular build output from the previous stage to the Nginx html directory
COPY --from=build /app/dist/browser /usr/share/nginx/html
# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80 for the web server
EXPOSE 80
# Start Nginx in the foregrounddd
CMD ["nginx", "-g", "daemon off;"]
