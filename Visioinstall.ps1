## Visio Install Script v4 created by Matt Leach
##this script is intended to install office 365 and visio pro 2019 using a provided key from our group.
##
Write-Output "Welcome to the TCHD Visio 2019 Pro installer"
$Key = Read-Host -Prompt 'Input Visio 2019 Professional Key:' ##This requests the license key
Write-Output "Creating XML"
New-Item -Name "VisioBase.xml"
## This creates the base XML file to use in the next part of the install
$xmlcontent = @"
<Configuration ID="55ef1db3-aef4-4217-a41d-42a7e143f4bb">
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Bing" />
    </Product>
    <Product ID="VisioPro2019Volume" PIDKEY="VISIOKEY">
      <Language ID="en-us" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Bing" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="PinIconsToTaskbar" Value="TRUE" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <AppSettings>
    <Setup Name="Company" Value="TCHD" />
  </AppSettings>
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
"@
Add-Content -Path .\VisioBase.xml -Value $xmlcontent
$con = Get-Content .\VisioBase.xml
$con | % { $_.Replace("VISIOKEY", $Key) } | Set-Content .\VisioInstall.xml
Write-Output "File Created, executing install of Visio Pro 2019 and Office 365"
##This should run the install of office and visio 2019 pro based on the created xml file VisioInstall.xml
Write-Output "Starting download..." ##Starting download of 0365+Visio Pro 2019
./setup.exe /download .\VisioInstall.xml ##This should work but untested
loop
$size = Get-ChildItem -Path .\office -Sum ##loops until the var "size" does not change
Write-Output $size ##This should show the size of the download as a way to flag if the download is slow or not working, outputs to the console window
/loop
Write-Output "Download complete starting install..."
./setup.exe /configure .\VisioInstall.xml ##This should work but untested
Write-Output "Install complete, press any key to clean up."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
##cleanup
Remove-Item .\VisioBase.xml
Remove-Item .\VisioInstall.xml
