To add HTTPS support to your local open-webui container, you'll need to configure a reverse proxy that handles the SSL termination and forwards traffic to your webui container on the appropriate HTTP or HTTPS port. A popular choice for this task is Nginx, as it is lightweight and can easily be configured for this purpose.

Here's a step-by-step guide to setting up HTTPS with Nginx as a reverse proxy for your open-webui container:

1. **Install Nginx**:
   - On Ubuntu/Debian systems, you can install Nginx using the following commands:
     ```
     sudo apt-get update
     sudo apt-get install nginx
     ```

2. **Obtain an SSL Certificate**:
   - You can get a free SSL certificate from Let's Encrypt or use any other certificate authority (CA) of your choice. For Let's Encrypt, you can use the Certbot tool.
     - Install Certbot and the Nginx plugin:
       ```
       sudo apt-get install certbot python3-certbot-nginx
       ```
     - Run Certbot and follow the prompts to obtain your certificate:
       ```
       sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
       ```
     - Replace `yourdomain.com` with your actual domain name.

3. **Configure Nginx as a Reverse Proxy**:
   - Edit the Nginx configuration file (usually located at `/etc/nginx/sites-available/default` on Ubuntu/Debian systems) and add the following server block, adjusting the `server_name`, paths, and other settings as necessary:
     ```
     server {
         listen 80;
         server_name yourdomain.com www.yourdomain.com;

         location / {
             proxy_pass http://localhost:YOUR_WEBUI_PORT;
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection 'upgrade';
             proxy_set_header Host $host;
             proxy_cache_bypass $http_upgrade;
         }
     }

     server {
         listen 443 ssl;
         server_name yourdomain.com www.yourdomain.com;

         ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
         ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

         location / {
             proxy_pass http://localhost:YOUR_WEBUI_PORT;
             proxy_http_version 1.1;
             proxy_set_header Upgrade $http_upgrade;
             proxy_set_header Connection 'upgrade';
             proxy_set_header Host $host;
             proxy_cache_bypass $http_upgrade;
         }
     }
     ```
   - Replace `yourdomain.com` with your actual domain name and `YOUR_WEBUI_PORT` with the port number your webui container is listening on.

4. **Test Nginx Configuration and Restart**:
   - Test the Nginx configuration for syntax errors:
     ```
     sudo nginx -t
     ```
   - If no errors are reported, restart Nginx to apply the changes:
     ```
     sudo systemctl restart nginx
     ```

5. **Update Firewall Settings** (if applicable):
   - If you have a firewall enabled (like UFW on Ubuntu), you may need to allow HTTPS traffic:
     ```
     sudo ufw allow 'Nginx Full'
     ```

6. **Update Domain's DNS Settings**:
   - Make sure that your domain's DNS settings are pointing to the IP address of your server. If you're using a dynamic IP address, you might want to use a Dynamic DNS (DDNS) service.

7. **Test HTTPS Connection**:
   - Visit `https://yourdomain.com` in your web browser to see if the HTTPS connection is working.

Remember to replace placeholder values like `yourdomain.com` and `YOUR_WEBUI_PORT` with your actual domain name and the port number your webui container uses.

Please note that if your webui container is running on a non-standard port (other than the default HTTP port 80 and HTTPS port 443), you need to adjust the Nginx reverse proxy configuration accordingly. Additionally, ensure your webui container is configured to listen on the specified ports, and your firewall rules allow traffic on those ports.