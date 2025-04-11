#!/bin/bash

# Create log function
log_debug() {
  echo "$(date): DEBUG - $1" >> /var/log/user-data.log
}

# Start logging
log_debug "Starting userdata script execution"
log_debug "Environment variables:"
log_debug "secrets_manager_region=${secrets_manager_region}"
log_debug "db_password_secret_name=${db_password_secret_name}"
log_debug "application_port=${application_port}"
log_debug "db_host=${db_host}"
log_debug "db_port=${db_port}"
log_debug "db_name=${db_name}"
log_debug "db_username=${db_username}"
log_debug "s3_bucket_name=${s3_bucket_name}"
log_debug "environment=${environment}"

# Retrieve database password from Secrets Manager
log_debug "Attempting to retrieve database password from Secrets Manager"
DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --region ${secrets_manager_region} \
  --secret-id ${db_password_secret_name} \
  --query SecretString \
  --output text)

# Log the actual password (REMOVE AFTER DEBUGGING!)
log_debug "Retrieved DB_PASSWORD=${DB_PASSWORD}"

# Create environment file for the application
log_debug "Creating environment file at /opt/csye6225/webapp/.env"
cat > /opt/csye6225/webapp/.env << EOL
PORT=${application_port}
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USERNAME=${db_username}
DB_PASSWORD=$DB_PASSWORD
S3_BUCKET_NAME=${s3_bucket_name}
NODE_ENV=production
EOL

# Log the contents of the file (REMOVE AFTER DEBUGGING!)
log_debug "Contents of .env file:"
log_debug "$(cat /opt/csye6225/webapp/.env)"

# Set proper ownership and permissions for security
log_debug "Setting ownership and permissions for .env file"
chown csye6225:csye6225 /opt/csye6225/webapp/.env
chmod 600 /opt/csye6225/webapp/.env
log_debug "File permissions set: $(ls -la /opt/csye6225/webapp/.env)"

# Restart application service to apply new environment variables
log_debug "Restarting csye6225 service"
systemctl restart csye6225.service
log_debug "Service restart result: $?"
log_debug "Service status: $(systemctl status csye6225.service | grep Active)"

# Configure CloudWatch Agent
log_debug "Creating CloudWatch Agent configuration"
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOL'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/csye6225/webapp/logs/app.log",
            "log_group_name": "csye6225-application-logs",
            "log_stream_name": "${environment}-application",
            "retention_in_days": 7
          },
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "csye6225-system-logs",
            "log_stream_name": "${environment}-userdata",
            "retention_in_days": 7
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "CSYE6225/CustomMetrics",
    "metrics_collected": {
      "statsd": {
        "service_address": ":8125",
        "metrics_collection_interval": 10,
        "metrics_aggregation_interval": 60
      }
    }
  }
}
EOL

log_debug "CloudWatch configuration created"
log_debug "CloudWatch config: $(cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json)"

# Restart CloudWatch Agent to apply new configuration
log_debug "Restarting CloudWatch Agent"
systemctl restart amazon-cloudwatch-agent
log_debug "CloudWatch Agent restart result: $?"
log_debug "CloudWatch Agent status: $(systemctl status amazon-cloudwatch-agent | grep Active)"

# Log available services to help with debugging
log_debug "Available systemd services:"
log_debug "$(systemctl list-units --type=service | grep running)"

# Check network connectivity
log_debug "Network connectivity:"
log_debug "$(netstat -tulpn | grep LISTEN)"

# Check AWS credentials
log_debug "AWS credentials:"
log_debug "$(aws sts get-caller-identity || echo 'Failed to get AWS identity')"

# Log completion
log_debug "Auto Scaling user-data script completed successfully"
echo "$(date): Auto Scaling user-data script completed successfully" >> /var/log/user-data.log

# SECURITY WARNING in the logs
log_debug "WARNING: This log contains sensitive information and should be removed after debugging!"