Write-Output "Backing up Connect Server data."
Copy-Item -Path "C:\ProgramData\Objectif Lune\OL Connect" -Destination "C:\Connect\Backup\Connect Server\ProgramData" -Recurse -Force
