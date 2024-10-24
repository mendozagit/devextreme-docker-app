# Stage 1: Building the Angular application
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install the application's dependencies and Angular CLI
RUN npm install && npm install -g @angular/cli

# Copy the rest of the application to the container
COPY . .

# Build the application in production mode
RUN ng build devextreme-docker-app --configuration production

# Stage 2: Final image using Nginx to serve the static files
FROM nginx:alpine

# Copy the compiled files from the build stage
COPY --from=build /usr/src/app/dist/devextreme-docker-app /usr/share/nginx/html

# Copy a custom Nginx configuration file if necessary
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
