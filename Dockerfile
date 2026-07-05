FROM nginx:alpine

# Remove the default Nginx landing page
RUN rm /usr/share/nginx/html/index.html

# Inject the required static message into the web server directory
RUN echo '<h1>PRT – CI/CD Completed Successfully</h1>' > /usr/share/nginx/html/index.html

# Expose port 80 inside the container
EXPOSE 80

# Run Nginx in the foreground so the container stays active
CMD ["nginx", "-g", "daemon off;"]
