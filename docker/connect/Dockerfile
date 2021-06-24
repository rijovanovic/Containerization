FROM mcr.microsoft.com/windows/servercore:ltsc2019
WORKDIR /connect
COPY resources ./
COPY ["resources/secrets", "C:/ProgramData/F5C3S4/"]
COPY ["resources/azure-logs", "C:/"]

# Setup admin user account
RUN net user /add ConnectAdmin
RUN net localgroup Administrators ConnectAdmin /add
USER ConnectAdmin
RUN powershell c:\connect\scripts\set_password.ps1

# Switch back and run silent Connect Installer
USER ContainerAdministrator
WORKDIR /connect/setup
RUN install.bat
WORKDIR /connect

RUN powershell c:\connect\scripts\backup.ps1

RUN powershell c:\connect\scripts\azure-logs.ps1

# Delete setup files
#RUN powershell Remove-Item C:\\connect\\setup -Force  -Recurse -ErrorAction SilentlyContinue

EXPOSE 9340/tcp

# Default for daemon mode: starts connect server and waits until the server services is stopped
CMD powershell c:\connect\scripts\start_connect.ps1