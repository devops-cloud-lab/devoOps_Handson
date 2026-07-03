# Use a lightweight base image
FROM nginx:alpine

# Copy your HTML file into Nginx default directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Nginx runs automatically as the container’s entrypoint

