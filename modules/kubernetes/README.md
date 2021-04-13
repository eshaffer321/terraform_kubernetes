# Cert creation notes
Create a droplet and do the following
https://superuser.com/questions/1437978/certbot-error-unrecognized-arguments-dns-digitalocean-credentials

## Commands
Here is what I ran 
`sudo certbot certonly --dns-digitalocean --dns-digitalocean-credentials creds.ini --dns-digitalocean-propagation-seconds 60 -d commandyourmoney.co -d *.commandyourmoney.co`