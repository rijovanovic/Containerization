# Containerization

This repository holds files to create and use the Connect and OL MySQL container through docker, docker-compose or in a Kubernetes environment.

## Support

If you have any questions or need support the best place to go to is the Teams-Docker -> [General](https://teams.microsoft.com/l/channel/19%3a79da951ed9ad464598d9bdfd7872dd74%40thread.skype/General?groupId=2178f7bc-919e-41a5-a676-f8ba9ac36761&tenantId=f95d2a62-45c4-4406-b95f-9685a3ab37b0) channel and post your question there.

## Downloading files

You can use any git client to clone this repository to get the files on your local machine. If you are on the Bitbucket site you can also use the top right ... menu button and select Download to download the repository.

# Running Connect Containers Locally
## Prerequisistes
You have access to the [azure portal](https://portal.azure.com) and to the *olcloud* organization / subscription / tenant. You should have received an invite by email, you need to accept that invitation and follow the directions.

Install [Docker Desktop](https://www.docker.com/products/docker-desktop) in a VM or directly on your physical machine. In both cases the minimum Windows 10 version is Pro or Enterprise and 2004/20H1 or higher.

>Note that if you also use VMWare on your physical machine there are some limitations when you install Docker Desktop not in a VM, see [this article](https://objlune.sharepoint.com/sites/TEAM-TECHNICAL-CONTACT/_layouts/OneNote.aspx?id=%2Fsites%2FTEAM-TECHNICAL-CONTACT%2FShared%20Documents%2FTeam%20Technical%20Contact&wd=target%28Knowledge%20Base%2FContainers.one%7C03CC98BD-8B05-410B-BB45-FAB5DA9F5E9B%2FDocker%20Desktop%20%26%20VMWare%7C12BA1677-45D3-4F47-B00D-49DEE84EC387%2F%29) for more details. If you are not sure you can install Docker Desktop in a VM that is the safest option. The VM should have at least 10 GB of memory and a 80 GB hard disk size. In VMWare in the *Settings -> Processors* section of the VM enable the *Virtualize Intel VT-x/EPT or AMD-V/RVI* setting.

> To be able to run Windows containers Docker Desktop requires the Windows features Hyper-V and Containers to be turned on. You can do this by opening a Admin PowerShell and execute this command: `Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V","Containers") -All` a restart is required. If you need to do this on your host machine (not in a VM) it might change the magic number and affect any Connect License that you have on the host, not in the container itself.

> During the installation of Docker Desktop it will by default install the Windows WSL 2 feature to run Linux containers. You can use that but you can also use Hyper-V to run Linux containers. If you install WSL 2 you will get an error that you must still install the Linux kernel update package. That dialog has some instructions on how to do that. If you don't install WSL 2 you will get an error and should click continue and the click the *Use Hyper-V* button to let Linux containers run in Hyper-V. Connect containers are Windows containers so this setting is not relevant to that but you might also want to run a Node-RED container which is a linux container. The easier option is probably to not install WSL 2 and let Docker Desktop use Hyper-V for both Windows and Linux containers.

>After installation make sure that Docker Desktop is running in Windows mode and not in Linux mode, it defaults to Linux mode. If you right click on the Docker icon in the system tray you will see a context menu. If there is a menu item *Switch to Windows containers...* then you have to click that. If the menu item says *Switch to Linux containers...* you are already in Windows mode.

Install [Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

Execute the following commands on the command prompt:

`az login --tenant d48af302-5755-46c0-9a48-7b7d0eb4ba37`
>This will open a webbrowser where you have to log in with your OL domain user and password. If you get a *No Subscription* error IT will have to add you to the olcloud tenant.

`az acr login --name olakspoccr`
>This will log you into the azure container registry. If you get any permission errors here IT might first have to give you pull (read) rights on the repository.

The steps above are only necessary once. You might have to do the login commands later again but typically that is only necessary once every couple of weeks.

## Getting Started
The easiest way to get everything up and running locally is to use docker compose. Make sure that on your host the port for MySQL (3306) and Connect (9340) are not in use, you might have to stop those services. Open a command prompt or PowerShell and go the `docker\compose` folder of this repository, then type:

`docker-compose up`

>If you get errors about the network when you do a docker-compose up you might have to do a `docker-compose down` first.

>If you get a *not implemented* error be sure that you type `docker-compose up` with the hypen - between docker and compose instead of a space. If you still get the error you should check that in Docker Desktop in *Settings -> Experimental Features* the *Use Docker Compose V2* option is unchecked. 

>If you get *file in use* errors it might be that port 9340 and/or 3360 are not free, you probably have to stop the MySQL and Connect service on the host first.

The docker-compose up command will pull the *connect* and *ol-mysql* container from our container registry in Azure and start hem both and will create the docker volumes. When the container is started it can take some time before Connect is fully started and the database is initialized and you can access the REST API.

Once Connect is started you should be able to view the cookbook by going to this URL: [http://localhost:9340/serverengine/html/cookbook/index.html](http://localhost:9340/serverengine/html/cookbook/index.html)

The default REST user is: `cloud-user` the default password is `nKTV3gSMv59rNOhTYzxm`

To shutdown the container press CTRL+C in the command prompt and it will do a docker-compose down.


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
The `docker\compose\docker-compose.yml` file and the Kubernetes config files will automatically use a transactional license (Nalpeiron) in Connect. This licenses uses the test product in Nalpeiron. This license code can be used for testing by multiple people at the same time. If you want to try a different license code you can change the configuration files and a restart of the container is necessary.

## Overriding preferences
To set specific preferences for the Connect container you can edit the preference files in the `docker\compose\prefs` folder. There are some sample files with comments in that folder. Note that these files will be read at startup of Connect and will override any preference with the same key name that exists in the normal preference file location.

## Database connection
The docker compose configuration will automatically start two containers. One is the OL MySQL Windows container the other is the Connect container. You can however also use a different external database. If you want to change the database connection of the Connect container you can edit the `docker\compose\prefs\com.objectiflune.repository.ecliselink.generic.prefs` file and the password should be put into the `docker\compose\secrets\db.password` file as clear text.

Currently the OL MySQL Windows container uses a hardcoded `root` user and the password `XOkgmXxfXFEsdNUOl43!`

## Connect Version
The alpha version of the container is based on build [74](https://leonard.ca.objectiflune.com/job/cg/job/prod_connect/job/develop/74/) from the develop branch. So it contains everything from 2021.1.2 but also some tickets of 2021.2.

## Fonts
The operating system in the container contains only one default font. For your template to work correctly you need to [import the font](https://help.objectiflune.com/en/planetpress-connect-user-guide/2021.1/#designer/Styling_Formatting/Fonts.htm#toc-1) into the template.

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

You should check for errors in the terminal. Because the process will continue creating the image even if there are errors but the image will probably not work in that case.

You might experience a dialog popping up with "System cannot find the path specified" error. This error is shown while the script tries to extract the files from the self extracting archive (PReS_Connect_Setup_x86_64.exe). Unfortunately longs paths are not supported by the self extracting archive. The only way to resolve this is by making that path shorter where you cloned this git repository, for exampling placing it in c:\containerization.

There is also an issue with a specific version of Forticlient that prevents the script from mounting the ISO succesfully, this typically succeeds on the first run but fails in later runs after a timeout of several minutes. IT is looking into this, it is a general issue that also occurs when you mount ISO files using the normal Windows GUI.

# Kubernetes
On Kubernetes you have different tools to do the job that docker-compose does in a local environment. The `kubernetes` folder hold these configuration files. We have so far used these only on the Azure Kubernetes Service.