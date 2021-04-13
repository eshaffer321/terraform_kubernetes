# Setup
Right now the nexus credentials are being added manually through the drone cli. This should eventually be switched to be sourced from vault server. In the mean time here is the commands to run to set up nexus credentials
```
drone orgsecret add badass-budget-project docker_username drone
drone orgsecret add badass-budget-project docker_password <redacted>
 ```
 