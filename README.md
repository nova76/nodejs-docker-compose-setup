# nodejs-docker-compose-setup
 how to develop node.js under docker

sh ./setup.sh
After installing docker-compose run this. This sets up the container with a couple of questions.
The required data is as follows.
domain - domain, for example: example.com, default: server hostname 
service - the service name for example: test-dokcer , default: current folder name
network - docker network name, selectable
host - full domain, for example: test-docker.example.com 

sh ./init.sh
Starts the container and initializes the project in the ./app folder. It also installs the express.js module

if you want to access the application from the domain, you must set up the dns and install jwilder/nginx-proxy on the specified network
https://hub.docker.com/r/jwilder/nginx-proxy
