FROM mcr.microsoft.com/windows/servercore:ltsc2019
WORKDIR /connect
COPY resources ./

# Run silent Connect Installer
WORKDIR /connect/setup
RUN install.bat
WORKDIR /connect

RUN powershell c:\connect\scripts\prepare_database.ps1

EXPOSE 3306/tcp

# Default for daemon mode: starts MySQL server and waits until the service is stopped
CMD powershell c:\connect\scripts\start_mysql.ps1