# Nexus module
Installs nexus3 repository manager in the nexus namespace
Chart documentation and source can be found [here](https://github.com/Oteemo/charts/tree/master/charts/sonatype-nexus)


## Inital setup

### Run the setup script
There is a setup script that will change the admin password as well as create a few roles and users. Nexus may need to be initlized through the UI before these scripts are able to run. This is a manual step right now and should be automated at some point.

`./setup.sh`

Check the script to see what variables are required.

### Image pull secret for kubernetes
We will need an image pull secret to be used in the helm deployments
```
kubectl create secret docker-registry regcred \
 --docker-server=https://docker.commandyourmoney.co \
 --docker-username=<your-name> \
 --docker-password=<your-pword> \
 --docker-email=<your-email>
```
