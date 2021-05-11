$dockerImageName = "connect:latest"

# This script will automatically create a docker image from the Connect iso file in this folder
# You must execute this PS script from the same directory the script is located as it uses relative paths
# Don't forget to change the name of the docker image in the variable at the top of this file

# Delete old setup files
Get-ChildItem -Path "resources\setup" | Remove-Item -Recurse -Force -Exclude "install.bat", "install.properties", ".gitignore"

# Mount iso 
$iso = (Get-ChildItem *.iso)[0].Name
Write-Output "Using iso file: $iso"

$isoPath = (Get-Location).Path + "\" + $iso

$mountResult = Mount-DiskImage -ImagePath $isoPath

$driveLetter = ($mountResult | Get-Volume).DriveLetter
$sourcePath = $driveLetter + ":\*"

# Copy files from iso to setup folder
Write-Output "Copy files from ISO to setup folder..."
$destination = (Get-Location).Path + "\resources\setup"
Copy-Item -Path $sourcePath -Destination $destination -Recurse -Force

# Dismount iso
Dismount-DiskImage -ImagePath $isoPath

# Extract setup files
.\resources\setup\PReS_Connect_Setup_x86_64.exe -nr -gm2 '-InstallPath=".\\resources\\setup"'
# Command above returns immediately but extraction is still going on in background so we have to sleep here
Start-Sleep -s 5

docker build -t $dockerImageName .