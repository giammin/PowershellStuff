# imposta i permessi su una cartella per un utente 
# i permessi verranno propagati ai figli

$path = "C:\foldername"
$identity = "" # username or groupname or everyone
$rights = 'FullControl' #Other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')

$acl = Get-ACL $path
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)
$acl.AddAccessRule($accessRule)
Set-Acl $path $acl

#verifica
$acl.Access | format-table -autosize