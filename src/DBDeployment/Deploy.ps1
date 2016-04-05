# These variables should be set via the Octopus web portal:
#
# RoundhousE.ENV - The RoundhousE variable for running environment-specific scripts. Values are LOCAL, TEST, and DATATEST.
# SqlServerInstance - "." or ".\SqlExpress", since the Octopus agent has an instance named "."
# DatabaseName - TEG or TEG_TEST
# RoundhouseAction - This is used to determine an update or a restore
#
$roundhouse_version_file = ".\VERSION.TXT"
$roundhouse_exe_path = ".\rh.exe"
$scripts_dir = ".\DatabaseMigration\up"
$roundhouse_output_dir = ".\output"
if ($OctopusParameters) {
$env = $OctopusParameters["RoundhousE.ENV"]
$db_server = $OctopusParameters["SqlServerInstance"]
$db_name = $OctopusParameters["DatabaseName"]
$dbAction = $OctopusParameters["RoundhouseAction"]
} else {
Write-Host "No vars"
$env="LOCAL"
$db_server = ".\SqlExpress"
$db_name = "CodeCampServerLite"
$dbAction = "Rebuild"
}
Write-Host "RoundhousE is going to run on database: " $db_name
Write-Host "Executing RoundhousE for environment:" $env
if($dbAction -eq "Update"){
Write-Host "Update:"
set-executionpolicy -scope process bypass
Import-Module PSake
#Import-Module .\tools\psake\teamcity.psm1
exec { &$roundhouse_exe_path -s $db_server -d $db_name -f $scripts_dir --env $env --silent -o $roundhouse_output_dir -vf $roundhouse_version_file --transaction }
}
if($dbAction -eq "Rebuild"){
Write-Host "Rebuild:"
exec { &$roundhouse_exe_path -s $db_server -d $db_name -f $scripts_dir --env $env --silent -drop -o $roundhouse_output_dir -vf $roundhouse_version_file }
}