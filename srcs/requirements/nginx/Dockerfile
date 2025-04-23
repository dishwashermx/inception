# Use Debian Bullseye as the base image
FROM debian:bullseye

# Update package list and install Nginx and OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Copy the custom Nginx configuration file
COPY conf/default.conf /etc/nginx/nginx.conf

# Copy the SSL certificate and private key into the container
COPY tools/ssl/certificate.crt /etc/ssl/certs/certificate.crt
COPY tools/ssl/certificate.key /etc/ssl/private/certificate.key

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start Nginx in the foreground (no daemon mode)
CMD ["nginx", "-g", "daemon off;"]
