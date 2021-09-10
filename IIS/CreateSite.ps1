do {
    $SiteName = Read-Host -Prompt "nome del sito ES: testsite.it"
} until ($SiteName)

$PrimaryBinding = Read-Host -Prompt "binding principale ES: testsite.it o solo invio per utilizzare il nome del sito"

if (!$PrimaryBinding) {
    $PrimaryBinding=$SiteName
}
$OtherBindings = @()
do {
    $userInput = (Read-Host "altro binding ES: www.testsite.it o solo invio per uscire")
    if ($userInput) {$OtherBindings += $userInput}
}until (!$userInput)

$wwwroot = "c:\inetpub\wwwroot"
$iisfiles="c:\IIS_Files"
$rootupload= "Files"

Write-Host 'Riepilogo configurazioni'
Write-Host "Nome del sito: $SiteName"
Write-Host "Binding principale: $PrimaryBinding"
Write-Host "Bindings: $OtherBindings"
Write-Host "Path wwwroot: $wwwroot\$SiteName"
Write-Host "Path iisfiles: $iisfiles\$SiteName\$rootupload"


$goon = Read-Host -Prompt "y per continuare"
if ($goon -eq 'y') {
    
    New-Item -ItemType Directory -Force -Path $wwwroot\$SiteName
    New-Item -ItemType Directory -Force -Path $iisfiles\$SiteName\$rootupload

    Import-Module IISAdministration

    $manager = Get-IISServerManager

    $pool = $manager.ApplicationPools.Add($SiteName)

    $site = $manager.Sites.Add($SiteName, 'http', "*:80:$PrimaryBinding", "$wwwroot\$SiteName")
    $site.Applications['/'].ApplicationPoolName = $pool.Name
    $site.Applications['/'].VirtualDirectories.Add("/$rootupload","$iisfiles\$SiteName\$rootupload")
    foreach ($binding in $OtherBindings)
    {
        $site.Bindings.Add("*:80:$binding", 'http')
    }
    $site.Bindings.Add("*:21:$PrimaryBinding", 'ftp')

    $configSection = $manager.GetApplicationHostConfiguration().GetSection("system.applicationHost/sites")
    $baElement = Get-IISConfigCollection $configSection | Get-IISConfigCollectionElement -ConfigAttribute @{'Name'=$SiteName} |Get-IISConfigElement  -ChildElementName "ftpServer"  |Get-IISConfigElement  -ChildElementName "security"  |Get-IISConfigElement  -ChildElementName "authentication"  |Get-IISConfigElement  -ChildElementName "basicAuthentication"
    Set-IISConfigAttributeValue -ConfigElement $baElement -AttributeName "enabled" -AttributeValue true

    $manager.CommitChanges()
    Write-Host 'Sito creato!'
}else {
    Write-Host 'Operazione interrotta'    
}
