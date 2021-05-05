net start olconnect_mysql
Start-Sleep -s 5

Write-Output "Dropping and recreating objectiflune schema to get empty database."
$Command = "&`"C:\Program Files\Objectif Lune\OL Connect\MySQL\bin\mysql.exe`" -u root -pXOkgmXxfXFEsdNUOl43! -e 'drop schema objectiflune; create schema objectiflune;'"
Invoke-Expression $Command

net stop olconnect_mysql

Write-Output "Backing up MySQL data."
Copy-Item -Path "C:\ProgramData\Objectif Lune\OL Connect\MySQL\data" -Destination "C:\Connect\Backup\MySQL\data" -Recurse -Force

