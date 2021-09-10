# PowershellStuff
powershell commands and script



## powershell remoting

```
Enable-PSRemoting -force
winrm quickconfig
# be carefull, only behind a firewall
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
```


### firewall
check rules 
`Get-NetFirewallRule -Name 'WINRM-HTTP-In-TCP*'`
`Get-NetFirewallRule -Name 'WINRM-HTTP-In-TCP-PUBLIC' | Get-NetFirewallAddressFilter`
Set: `Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP-PUBLIC' -RemoteAddress Any`

Restart service: `Restart-Service WinRM`

### client
with WinRM service started just for trustedhosts edit

```
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/client '@{AllowUnencrypted="true"}'
Set-Item WSMan:localhost\client\trustedhosts -value *
```

# Roles and features for webserver iis

```
Install-WindowsFeature -Name Web-Server, Web-WebServer, Web-Common-Http, Web-Default-Doc, Web-Dir-Browsing, Web-Http-Errors, Web-Static-Content, Web-Health, Web-Http-Logging, Web-Performance, Web-Stat-Compression, Web-Dyn-Compression, Web-Security, Web-Filtering, Web-App-Dev, Web-Net-Ext, Web-Net-Ext45, Web-Asp-Net, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-WebSockets, Web-Ftp-Server, Web-Ftp-Service, NET-Framework-Features, NET-Framework-Core, NET-Framework-45-Features, NET-Framework-45-Core, NET-Framework-45-ASPNET, NET-WCF-Services45, NET-WCF-TCP-PortSharing45 -Restart
``` 


## file permissins
```
$acl = Get-Acl c:\NEWFOLDER\
$accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule("USERNAME OR GROUP","FullControl",'ContainerInherit, ObjectInherit','None', "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl  c:\NEWFOLDER\ $Acl

#test
Get-Acl c:\NEWFOLDER\ | format-table -autosize
(Get-Acl c:\NEWFOLDER\).Access | format-table -autosize
```

## install .msi
 
```
msiexec.exe /i rewrite_amd64_en-US.msi
```


## self signed certificate
```
New-SelfSignedCertificate -FriendlyName "SSL Certificate" -CertStoreLocation cert:\localmachine\my -DnsName localhost -NotAfter (Get-Date).AddYears(10)
```



## unzip

```
Expand-Archive c:\a.zip -DestinationPath c:\a
```

## create user
```
$Secure_String_Pwd = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
New-LocalUser "USERNAME" -Password $Secure_String_Pwd -Description "new user description" -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
```

