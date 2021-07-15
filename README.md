# Containerization

This repository holds files to create and use the Connect and OL MySQL container through docker, docker-compose or in a Kubernetes environment.

## Support

If you have any questions or need support the best place to go to is the Teams-Docker -> [General](https://teams.microsoft.com/l/channel/19%3a79da951ed9ad464598d9bdfd7872dd74%40thread.skype/General?groupId=2178f7bc-919e-41a5-a676-f8ba9ac36761&tenantId=f95d2a62-45c4-4406-b95f-9685a3ab37b0) channel and post your question there.

# Running Connect Containers Locally
## Prerequisistes
You have access to the [azure portal](https://portal.azure.com) and to the *olcloud* organization / subscription / tenant. You should have received an invite by email, you need to accept that invitation and follow the directions.

Install [Docker Desktop](https://www.docker.com/products/docker-desktop) in a VM or on your physical machine
>Note that if you also use VMWare on your physical machine there are some limitations when you install Docker Desktop not in a VM, see [this article](https://objlune.sharepoint.com/sites/TEAM-TECHNICAL-CONTACT/_layouts/OneNote.aspx?id=%2Fsites%2FTEAM-TECHNICAL-CONTACT%2FShared%20Documents%2FTeam%20Technical%20Contact&wd=target%28Knowledge%20Base%2FContainers.one%7C03CC98BD-8B05-410B-BB45-FAB5DA9F5E9B%2FDocker%20Desktop%20%26%20VMWare%7C12BA1677-45D3-4F47-B00D-49DEE84EC387%2F%29) for more details. If you are not sure you can install Docker Desktop in a VM that is the safest option, be sure to give the VM enough memory (8 GB minimum).

>After installation make sure that Docker Desktop is running in Windows mode and not in Linux mode. If you right click on the Docker icon in the system tray you will see a context menu. If there is a menu item *Switch to Windows containers...* then you have to click that. If the menu item says *Switch to Linux containers...* you are already in Windows mode.

Install [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

Execute the following commands on the command prompt:

`az login --tenant d48af302-5755-46c0-9a48-7b7d0eb4ba37`
>This will open a webbrowser where you have to log in with your OL domain user and password. If you get a *No Subscription* error IT will have to add you to the olcloud tenant.

`az acr login --name olakspoccr`
>This will log you into the azure container registry. If you get any permission errors here IT might first have to give you pull (read) rights on the repository.

The steps above are only necessary once. You might have to do the login commands later again but typically that is only necessary once in a couple of weeks.

## Getting Started
The easiest way to get everything up and running locally is to use docker compose. Make sure that on your host the port for MySQL (3306) and Connect (9340) are not in use, you might have to stop those services. Open a command prompt or PowerShell and go the `docker\compose` folder of this repository, then type:

`docker-compose up`

This will pull the *connect* and *ol-mysql* container from our container registry in Azure and start hem both and will create the docker volumes. When the container is started it can take some time before Connect is fully started and the database is initialized and you can access the REST API.

Once Connect is started you should be able to view the cookbook by going to this URL: [http://localhost:9340/serverengine/html/cookbook/index.html](http://localhost:9340/serverengine/html/cookbook/index.html)

The default REST user is: `cloud-user` the default password is `nKTV3gSMv59rNOhTYzxm`

## Inspecting volumes and log files
Volumes allow you to save the state information outside of the container image. If for example one container goes down you can start another container that uses the same volumes to continue without losing data.

The docker compose configuration will create three volumes:
* db 
  * Mounted in the MySQL container into `c:\ProgramData\Objectif Lune\OL Connect\MySQL\data`
* connect-data
  * Mounted in the Connect container into `c:\Users\connectadmin\Connect`
* connect-prefs
  * Mounted in the Connect container into `c:\ProgramData\Objectif Lune\OL Connect`

By default docker desktop stores volumes on the host in this location: `C:\ProgramData\Docker\volumes` which makes it easy to inspect any of the files in the volumes on the host. For example if you want to take a look at the log files of Connect Server and the engines they are located in the `C:\ProgramData\Docker\volumes\compose_connect-data\_data\logs` folder.

## License
The `docker\compose\docker-compose.yml` file and the Kubernetes config files will automatically use a transactional license (Nalpeiron) in Connect. This licenses uses the test product in Nalpeiron. This license code can be used for testing by multiple people at the same time. If you want to try a different license code you can change the configuration files.

You might run into an issue where token consumption by the Weaver engine occasionally gives an error. That is a known issue, there is a Jira ticket for that: [SHARED-82839](https://jira.ca.objectiflune.com/browse/SHARED-82839)

## Overriding preferences
To set specific preferences for the Connect container you can edit the preference files in the `docker\compose\prefs` folder. There are some sample files with comments in that folder. Note that these files will be read at startup of Connect and will override any preference with the same key name that exists in the normal preference file location.

## Database connection
The docker compose configuration will automatically start two containers. One is the OL MySQL Windows container the other is the Connect container. You can however also use a different external database. If you want to change the database connection of the Connect container you can edit the `docker\compose\prefs\com.objectiflune.repository.ecliselink.generic.prefs` file and the password should be put into the `docker\compose\secrets\db.password` file as clear text.

Currently the OL MySQL Windows container uses a hardcoded `root` user and the password `XOkgmXxfXFEsdNUOl43!`

## Connect Version
The alpha version of the container is based on build [35](https://leonard.ca.objectiflune.com/job/cg/job/prod_connect/job/develop/35/) from the develop branch. So it contains evertyhing from 2021.1 but also some tickets of 2021.2.

## Memory Limits
Docker Desktop will run Windows containers using Hyper-V isolation. It will give each container only 1 GB and 2 vCPUs. The docker compose file has a memory setting that increases this to 8 GB.

## Visual Studio Code
You can also open this project in [Visual Studio Code](https://code.visualstudio.com/). When you open the project, VS code should ask you to install the recommended extensions that we have defined for this project. 

These extensions add a Docker button to the left sidebar. In that view you can easily see what images, containers and volumes you have on your machine. If you have the docker-compose.yml file open you can also right click in the editor to run or stop it.

# Building a Connect container from an ISO file
You can also use this repository to build a Connect container docker image from a Connect Setup ISO file.

Step by step:
* Copy the iso file into the `docker\connect` folder
* Open a PowerShell terminal and go to the `docker\connect` folder
* Execute the `docker\connect\build-image-from-iso.ps1` script

This will extract the ISO, extracts the silent setup files and also run docker build to create the image locally. 

There are files in the `docker\connect\image\resources` folder that are used during this process to configure the silent setup and also the container.

# Kubernetes
On Kubernetes you have different tools to do the job that docker-compose does in a local environment. The `kubernetes` folder hold these configuration files. We have so far used these only on the Azure Kubernetes Service.