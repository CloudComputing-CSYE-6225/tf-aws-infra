#!/bin/bash

if ! command -v aws &> /dev/null; then
  apt-get update
  apt-get install -y awscli
fi

# Retrieve database password from Secrets Manager
DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --region ${secrets_manager_region} \
  --secret-id ${db_password_secret_name} \
  --query SecretString \
  --output text)

# Create environment file for the application
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

# Set proper ownership and permissions for security
chown csye6225:csye6225 /opt/csye6225/webapp/.env
chmod 600 /opt/csye6225/webapp/.env

# Restart application service to apply new environment variables
systemctl restart csye6225.service

# Configure CloudWatch Agent
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

# Restart CloudWatch Agent to apply new configuration
systemctl restart amazon-cloudwatch-agent

# Log completion
echo "$(date): Auto Scaling user-data script completed successfully" >> /var/log/user-data.log