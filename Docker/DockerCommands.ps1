#Creds
docker login -u <username> -p <password> <registry URL>

#Images
docker pull <image name>:<image tag>
docker run -d -p <port>:<port> --name <name> --restart-always --label <label image> -v <volumeMount> --isolation <process>
docker run -d -p 9000:9000 --name portainer --restart always --label eid.portainer.hideme=true -v \\.\pipe\docker_engine:\\.\pipe\docker_engine -v c:\data\portainer:C:\data --isolation process eidci.azurecr.io/portainer 
docker tag <source image> <target image>

#Clean
docker container rm $(docker container ls --filter status=exited -q --no-trunc)
docker rmi $(docker images -f "dangling=true" -q --no-trunc) # Dangling images

# Swarm
docker swarm join --token SWMTKN-1-4boilbaox7mmq20j1cjtrp0nxnxlgkf7ztmybvs7zw37v5w2r1-5chp9w83fw9ugoviip56t69h8 10.0.4.5:2377
docker node update --label-add role=worker 

# Stack
docker stack deploy -c <yaml file> rb-uat --with-registry-auth

# Firewall
# Opening Firewall for docker swarm
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
New-NetFirewallRule -DisplayName "Allow Inbound Port 2377" -Direction Inbound -LocalPort 2377 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 9000" -Direction Inbound -LocalPort 9000 -Protocol TCP -Action Allow

# Label
docker node update --label-add role=worker wvm1
docker node update --label-rm wvm2