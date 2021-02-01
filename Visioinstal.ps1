##this script is to add a visio key to an included xml file
$Key = Read-Host -Prompt 'Input Key'
$con = Get-Content .\test.xml
$con | % { $_.Replace("VISIOKEY", $Key) } | Set-Content .\test2.xml
##This should run the install of office and visio 2019 pro
setup /download .\test2.xml
setup /configure .\test2.xml
