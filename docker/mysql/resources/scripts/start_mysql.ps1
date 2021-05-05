#Check if an empty volume is mounted in the MySQL data dir, if that is the case copy our backup into it
if (-Not (Test-Path -Path "C:\ProgramData\Objectif Lune\OL Connect\MySQL\data\mysql")) {
    Write-Output "MySQL data folder is empty. Assuming new empty volume is mounted copying initial data onto volume."
    Copy-Item -Path "C:\Connect\Backup\MySQL\data\*" -Destination "C:\ProgramData\Objectif Lune\OL Connect\MySQL\data\" -Recurse -Force
}

#Start Services
net start olconnect_mysql

(Get-Service OLConnect_MySQL).WaitForStatus('Stopped')