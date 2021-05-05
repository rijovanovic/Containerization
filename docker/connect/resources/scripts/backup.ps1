Write-Output "Backing up Connect Server data."
# Create this folder so we can mount secrets as a subfolder in it, k8s will not mount it if the parent folder doesn't exist.
New-Item -Path "C:\ProgramData\Objectif Lune\OL Connect" -Name "Initialization" -ItemType "directory"
Copy-Item -Path "C:\ProgramData\Objectif Lune\OL Connect" -Destination "C:\Connect\Backup\Connect Server\ProgramData" -Recurse -Force
