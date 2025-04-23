# Use the official Debian Bullseye image as base
FROM debian:bullseye

# Install MariaDB server
RUN apt-get update && apt-get install -y mariadb-server

# Copy the database setup script into the container
COPY tools/configure.sh /configure.sh

# Copy custom MySQL configuration
COPY conf/my.cnf /etc/mysql/my.cnf

# Make the setup script executable
RUN chmod +x /configure.sh

# Run the setup script when the container starts
ENTRYPOINT ["/configure.sh"]
