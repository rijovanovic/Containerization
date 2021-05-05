$password = ConvertTo-SecureString -String "Objlune!1" -AsPlainText -Force
Get-LocalUser -Name "ConnectAdmin" | Set-LocalUser -Password $password


