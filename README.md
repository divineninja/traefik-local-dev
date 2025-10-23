# Traefik Local Development with SSL

This setup provides a complete local development environment using Traefik as a reverse proxy with self-signed SSL certificates for `*.local.test` domains.

## 🚀 Quick Start

1. **Clone and setup:**
   ```bash
   cd /Users/reylimjr/Sites/traefik
   ```

2. **Generate SSL certificates:**
   ```bash
   ./generate-certs.sh
   ```

3. **Trust the SSL certificate (macOS):**
   ```bash
   sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./certs/local.test.crt
   ```

4. **Add hosts to `/etc/hosts`:**
   ```bash
   sudo tee -a /etc/hosts << EOF
   127.0.0.1 local.test
   127.0.0.1 traefik.local.test
   127.0.0.1 whoami.local.test
   127.0.0.1 app.local.test
   EOF
   ```

5. **Start the services:**
   ```bash
   docker-compose up -d
   ```

6. **Access your services:**
   - 🔧 **Traefik Dashboard**: https://traefik.local.test (admin/admin)
   - 📱 **Sample App**: https://app.local.test
   - 🆔 **WhoAmI Service**: https://whoami.local.test

## 📋 What's Included

### Services
- **Traefik**: Reverse proxy with SSL termination and dashboard
- **WhoAmI**: Simple service that shows request information
- **Nginx App**: Sample web application with custom HTML

### Features
- ✅ Automatic HTTPS redirection (HTTP → HTTPS)
- ✅ Self-signed SSL certificates for `*.local.test`
- ✅ Traefik dashboard with basic authentication
- ✅ Docker container auto-discovery
- ✅ Logging and monitoring
- ✅ Security headers middleware

## 🔧 Configuration

### Traefik Configuration
The main configuration is in `traefik.yml`:
- **Entry Points**: HTTP (80) and HTTPS (443)
- **Providers**: Docker with automatic service discovery
- **SSL**: Self-signed certificates for local development
- **Dashboard**: Available at https://traefik.local.test

### Docker Compose
The `docker-compose.yml` includes:
- Traefik service with necessary volumes and ports
- Sample applications with Traefik labels
- Shared network for service communication

## 🛠 Adding New Services

To add a new service with SSL support, add these labels to your service in `docker-compose.yml`:

```yaml
your-service:
  image: your-image
  networks:
    - traefik
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.your-service.rule=Host(`your-service.local.test`)"
    - "traefik.http.routers.your-service.tls=true"
    - "traefik.http.services.your-service.loadbalancer.server.port=80"
```

Don't forget to add the domain to your `/etc/hosts` file:
```bash
echo "127.0.0.1 your-service.local.test" | sudo tee -a /etc/hosts
```

## 📁 Project Structure

```
traefik/
├── docker-compose.yml      # Main Docker Compose configuration
├── traefik.yml            # Traefik configuration
├── generate-certs.sh      # SSL certificate generation script
├── certs/                 # SSL certificates directory
│   ├── local.test.crt     # SSL certificate
│   ├── local.test.key     # SSL private key
│   └── local.test.conf    # OpenSSL configuration
├── html/                  # Sample web application
│   └── index.html         # Landing page
├── logs/                  # Traefik logs
└── README.md              # This file
```

## 🔐 SSL Certificate Details

The generated certificate includes the following domains:
- `local.test`
- `*.local.test`
- `traefik.local.test`
- `whoami.local.test`
- `app.local.test`

### Certificate Information
- **Type**: Self-signed
- **Validity**: 365 days
- **Key Size**: 2048 bits
- **Algorithm**: SHA-256

## 🎯 Useful Commands

### View Traefik logs:
```bash
docker-compose logs -f traefik
```

### Restart Traefik:
```bash
docker-compose restart traefik
```

### View all running services:
```bash
docker-compose ps
```

### Stop all services:
```bash
docker-compose down
```

### Regenerate certificates:
```bash
./generate-certs.sh
docker-compose restart traefik
```

## 🐛 Troubleshooting

### Certificate not trusted
1. Make sure you've added the certificate to your system's trusted certificates
2. Restart your browser after adding the certificate
3. Check that the domains are in your `/etc/hosts` file

### Service not accessible
1. Verify the service is running: `docker-compose ps`
2. Check Traefik dashboard for routing rules
3. Ensure the domain is in `/etc/hosts`
4. Check Docker labels on your service

### Traefik dashboard not accessible
1. Check if Traefik container is running
2. Verify basic auth credentials (admin/admin)
3. Ensure `traefik.local.test` is in `/etc/hosts`

## 🔧 Development Tips

1. **Use the Traefik dashboard** to monitor your services and routing rules
2. **Check logs** regularly for any SSL or routing issues
3. **Add new domains** to both `/etc/hosts` and your service labels
4. **Restart Traefik** after configuration changes

## 📝 License

This configuration is provided as-is for local development purposes.

---

**Happy coding! 🎉**