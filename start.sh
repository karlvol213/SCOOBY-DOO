#!/bin/bash

# Use PORT provided by Railway, default to 80 if not set
PORT_ENV=${PORT:-80}

# Update Apache to listen on the Railway-provided port
sed -ri "s/Listen [0-9]+/Listen ${PORT_ENV}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

# Start Apache in foreground
apache2-foreground