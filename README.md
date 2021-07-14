# Containerization

This repository holds files to create and use the Connect and OL MySQL container through docker, docker-compose or in a Kubernetes environment.

## Prerequisistes
You have access to the [azure portal](https://portal.azure.com) and to the *olcloud* organization / subscription / tenant. You should have received an invite by email, you need to accept that invitation and follow the directions.

Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
>After installation make sure that Docker Desktop is running in Windows mode and not in Linux mode. If you right click on the Docker icon in the system tray you will see a context menu. If there is a menu item *Switch to Windows containers...* then you have to click that. If the menu item says *Switch to Linux containers...* you are already in Windows mode.

Install [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

Execute the following commands on the command prompt:

`az login --tenant d48af302-5755-46c0-9a48-7b7d0eb4ba37`
>This will open a webbrowser where you have to log in with your OL domain user and password. If you get a *No Subscription* error IT will have to add you to the olcloud tenant.

`az acr login --name olakspoccr`
>This will log you into the azure container registry. If you get any permission errors here IT might first have to give you pull (read) rights on the repository.

## Getting Started
The easiest way to get everything up and running is using docker compose. Make sure that on your host the port for MySQL (3306) and Connect (9340) are not in use, you might have to stop those services. Open a command prompt or PowerShell and go the `docker\compose` folder of this repository, then type:

`docker-compose up`

This will pull the *connect* and *ol-mysql* container from our container registry in Azure and start hem both and will create the docker volumes. When the container is started it can take some time before Connect is fully started and the database is initialized and you can access the REST API.

Once Connect is started you should be able to view the cookbook by going to this URL: [http://localhost:9340/serverengine/html/cookbook/index.html](http://localhost:9340/serverengine/html/cookbook/index.html)

The default REST user is: `cloud-user` the default password is `nKTV3gSMv59rNOhTYzxm`

You can inspect the log files of Connect by looking at the files in the volume. If you use Docker Desktop and the steps above the default location would be *C:\ProgramData\Docker\volumes\compose_connect-data\_data\logs*