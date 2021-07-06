#Check if an empty volume is mounted, if that is the case copy our backup into it
if (-Not (Test-Path -Path "C:\ProgramData\Objectif Lune\OL Connect\.settings")) {
    Write-Output "OL Connect subfolder in ProgramData is empty. Assuming new empty volume is mounted copying initial data onto volume."
    Copy-Item -Path "C:\Connect\Backup\Connect Server\ProgramData\*" -Destination "C:\ProgramData\Objectif Lune\OL Connect" -Recurse -Force
}

#Delete OSGI cache
if (Test-Path -Path "C:\Users\ConnectAdmin\Connect\.eclipse") {
    Remove-Item -Path "C:\Users\ConnectAdmin\Connect\.eclipse" -Recurse -Force
}

if ($Env:CONNECT_LICENSE_TEST_PRODUCT) {
    Write-Output "Switching Nalpeiron to test license product (115)."
    # Note that the value for the registry key is in decimal here, in a .reg file a DWORD value is in hex.
    Set-ItemProperty -Path "HKLM:\Software\Objectif Lune\OL Connect" -Name "ProductIdOverride" -Type "DWord" -Value 115
    Remove-Item -Recurse -Force -Path "C:\ProgramData\Objectif Lune\OL Connect\CloudLicense\*"
    $destinationPath = "C:\Program Files\Common Files\Objectif Lune\Licensing\ShaferFilechck.DLL";
    if (Test-Path $destinationPath) {
        Remove-Item $destinationPath -Force 
    }
    Copy-Item "C:\connect\scripts\ShaferFilechck.DLL" -Destination $destinationPath
}

# Start our license service to ensure it is running
net start cldsvc

if ($Env:CONNECT_LICENSE_CODE) {
    $Command = "&`"C:\Program Files\Common Files\Objectif Lune\Licensing\cldctl.exe`" retrieveLicense " + $Env:CONNECT_LICENSE_CODE
    Invoke-Expression $Command
    if ($?) {
        Write-Output "Successfully installed the transactional license."
    } else {
        Write-Output "Unable to install the transactional license."
        exit $LASTEXITCODE
    }
} else {
    Write-Output "No CONNECT_LICENSE_CODE environment variable was set, no license will be installed."
}

# Wait for MySQL to be fully started
Start-Sleep -s 10

# Start Connect
net start olconnect_server

# When the service stops the container should also stop
(Get-Service OLConnect_Server).WaitForStatus('Stopped')