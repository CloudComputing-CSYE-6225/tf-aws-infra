#!/bin/bash

# Create environment file for the application
cat > /opt/csye6225/webapp/.env << 'EOL'
PORT=${application_port}
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USERNAME=${db_username}
DB_PASSWORD=${db_password}
S3_BUCKET_NAME=${s3_bucket_name}
NODE_ENV=production
EOL

# Set proper ownership and permissions for security
chown csye6225:csye6225 /opt/csye6225/webapp/.env
chmod 600 /opt/csye6225/webapp/.env

# Restart application service to apply new environment variables
systemctl restart csye6225.service

# Log completion
echo "$(date): EC2 user-data script completed successfully" >> /var/log/user-data.log