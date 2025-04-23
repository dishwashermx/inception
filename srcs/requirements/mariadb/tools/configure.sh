#!/bin/bash

# Start MariaDB without networking and grant table checks (safe mode for setup)
mysqld_safe --skip-networking --skip-grant-tables &
sleep 5  # Give server time to start

# Create database and users with full access
mysql << EOF
FLUSH PRIVILEGES;  # Reload privilege tables
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;  # Create main database
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';  # Create app user
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';  # Grant user full DB access
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';  # Set root password
FLUSH PRIVILEGES;  # Apply all changes
EOF

# Stop the safe mode server
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
sleep 2  # Ensure it shuts down cleanly

# Start MariaDB normally with authentication
echo "✅ MariaDB initialized. Starting with authentication..."
exec mysqld_safe
