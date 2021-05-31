$password = ConvertTo-SecureString -String "UPLuxSk5B1A7P1eltoDA" -AsPlainText -Force
Get-LocalUser -Name "ConnectAdmin" | Set-LocalUser -Password $password -PasswordNeverExpires $true


