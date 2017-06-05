################################################################################################
################################################################################################
########################
########################            VM_CREATION_SCRIPT
########################            Created By: Eric Neudorfer
########################            Created 05182017
########################            Revised 05242017
########################
################################################################################################
################################################################################################


########################
########################
# To DO
#
# DONE - Create templates instead of WDS because of host name issues
# DONE - Tempaltes for IIS/SQL/VANILLA
# Use name to move VMs to correct location
# DONE - Use name to select proper template
# Push process to background to enable multiple runs
# If not DHCP change IP address based on location / Pull from NETBOX
# WSUS Server for quicker updates after deployemnt (? Not necesearry if using templates keept up to date?)
# Next Steps?
# Server build from email with Hostname 
#       -Email SVC account
#       -Kick off server build based off name
#       - Kick off email success/fail
# Specify DEV/MYBOFI Domain
# Add Error Logging
# CSV Input support



#function New_VM { 
#Param($Servername)

#$VM_name = $Servername

$VerbosePreference = 'Continue' #Change to SilentContinue to remove verbose / Continue For verbose


<#
### SET WINDOW SIZE
$pshost = Get-Host
$psWindow = $pshost.UI.RawUI
$newSize =$psWindow.BufferSize
$newSize.Height = 4000
$newSize.Width = 200
$psWindow.BufferSize = $newSize
$newSize = $psWindow.WindowSize
$newSize.Height = 24
$newSize.Width = 60
$psWindow.WindowSize= $newSize
#>

########################
########################
# Error Logging
<#
Write-Output "This is a test message."
Write-Verbose "This is a verbose message." -Verbose
Write-Warning "This is a warning message."
Write-Error "This is an error message."
#>
########################
########################
# Get VM Name 

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$VM_name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a server name", "Computer") 


########################
########################
# Request credentials

#$mycredentials =  Get-Credential
 
 ########################
########################
# Deploy credentials
$user = 
$password = 


########################
########################
##  Connect VI SERVER 
## Load Snapins 

Add-PsSnapin VMware.VimAutomation.Core -ea "SilentlyContinue"

$array = #PUT VCENTER SERVERS HERE
for($count=0;$count -lt $array.length; $count++)
{
# Connect to vCenter
connect-viserver $array[$count]  -credential $mycredentials 
}
 

########################
########################
# Folder NOT Present Continue
#        ###
function filenotpresent { 

[String]$File = "\\$VM_name\c$\MININIT\Scripts\LTICleanup.wsf"
                
$RetryCount = 0; $Completed = $false

while (-not $Completed) {
    if (Test-Path -LiteralPath $File) {
    Write-Verbose "File found, retrying in 20 seconds."
            Start-Sleep '20'
            $RetryCount++
      
        } else {
            Write-Verbose "File Not Found. Continuing."
              $Completed = $true
        }
        }}
########################
########################
# Folder Present Continue
#
function filepresent {
[String]$File = "\\$VM_name\c$\Windows" #"\\$VM_name\c$\MININIT\Scripts\LTICleanup.wsf"
                
$RetryCount = 0; $Completed = $false

while (-not $Completed) {
    if (-not (Test-Path -LiteralPath $File)) {
    Write-Verbose "File Not Found, retrying in 20 seconds."
            Start-Sleep '20'
            $RetryCount++
      
        } else {
            Write-Verbose "File found. Continuing."
              $Completed = $true
        }
        }}

########################
########################
# Seperate name into sub strings

$L = ($VM_name).Substring(0,2) #Location
$E = ($VM_name).Substring(2,1) #PROD/DEV/STG/UAT
$T = ($VM_name).Substring(3,1) #VLAN
$F = ($VM_name).Substring(5,3) #Template
$D = ($VM_name).Substring(8,3) #APP DESCRIPTION
$ID = ($VM_name).Substring(12,1) #VLAN ID
$IT = ($VM_name).Substring(14,1) #ITERATION (NO IMPACT)
 
 
########################
########################
# Print variables for sanity check

Write-Verbose "This is location: $L"
Write-Verbose "This is Enviornment: $E"
Write-Verbose  "This is VLAN: $V"
Write-Verbose  "This is This is Server Type: $T"
Write-Verbose "This is App Description: $D"
Write-Verbose "This is VLAN ID: $ID"
Write-Verbose "This is Server Iteration: $IT"
Write-Verbose "Use tempalte:" $template

########################
########################
# FUNCTIONS

function location { 
 if ($L -eq "SD") {write-host -foregroundcolor green "San Diego"} 
 elseif ($L -eq "AZ") {write-host -foregroundcolor green "Arizona"}  
  elseif ($L -eq "LJ") {write-host -foregroundcolor green "La Jolla"}  
   elseif ($L -eq "EG") {write-host -foregroundcolor green "East Gate"}  
    elseif ($L -eq "TC") {write-host -foregroundcolor green "Towne Centre"}  
     elseif ($L -eq "LV") {write-host -foregroundcolor green "Los Vegas"} 
      elseif ($L -eq "UT") {write-host -foregroundcolor green "Utah"}  
       else {write-host -foregroundcolor red "Invalid Selection"   }  
                   }
function enviornment { 
 if ($E -eq "P") {write-host -foregroundcolor green "Production"} 
 elseif ($E -eq "D") {write-host -foregroundcolor green "Development"}  
  elseif ($E -eq "S") {write-host -foregroundcolor green "Staging"}  
   elseif ($E -eq "U") {write-host -foregroundcolor green "User Acceptance Testing"}  
    elseif ($E -eq "Q") {write-host -foregroundcolor green "Quality Assurance"}  
     elseif ($E -eq "T") {write-host -foregroundcolor green "Testing"} 
       else {write-host -foregroundcolor red "Invalid Selection"   }  
         }
function vlan { 
 if ($V -eq "A") {write-host -foregroundcolor green "Application"} 
 elseif ($V -eq "D") {write-host -foregroundcolor green "Database"}  
  elseif ($V -eq "L") {write-host -foregroundcolor green "LoadBalancing"}  
   elseif ($V -eq "S") {write-host -foregroundcolor green "Server"}  
    elseif ($V -eq "V") {write-host -foregroundcolor green "VOIP"}  
     elseif ($V -eq "W") {write-host -foregroundcolor green "Website"} 
      elseif ($V -eq "Z") {write-host -foregroundcolor green "DMZ"}  
       else {write-host -foregroundcolor red "Invalid Selection"   }  
         }


function vlan_id { 
 if ($ID -eq "1") {write-host -foregroundcolor green "1"} 
 elseif ($ID -eq "2") {write-host -foregroundcolor green "2"}  
  elseif ($ID -eq "3") {write-host -foregroundcolor green "3"}  
   elseif ($ID -eq "4") {write-host -foregroundcolor green "4"}   
       else {write-host -foregroundcolor red "Invalid Selection"   }  
         }

########################
########################
# Choose Template
 if ($T -eq "W") { '$template ="IIS_05242017" ''$networkadapter = "WEB2-VLAN104-10.150.5.0-24"'} 
 elseif ($T -eq "D") { '$template ="SQL_05242017"'' $networkadapter = "DB1-VLAN102-10.150.3.0-24"'}  
       else { '$template ="SQL_05242017"'' $networkadapter = "App2-VLAN105-10.150.6.0-24"'}  


########################
########################
# Change IP Function	   
<#
Function Set-WinVMIP ($VM, $HC, $GC, $IP, $SNM, $GW){
 $netsh = "c:\windows\system32\netsh.exe interface ip set address ""Local Area Connection"" static $IP $SNM $GW 1"
 Write-Host "Setting IP address for $VM..."
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh
 Write-Host "Setting IP address completed."
}
 
Connect-VIServer MYvCenter
 
$VM = Get-VM ( Read-Host "Enter VM name" )
$ESXHost = $VM | Get-VMHost
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "", "")
 
$IP = "192.168.0.81"
$SNM = "255.255.255.0"
$GW = "192.168.0.1"
 
Set-WinVMIP $VM $HostCred $GuestCred $IP $SNM $GW	   
#>

########################
########################
# Run Functions


location
enviornment
vlan
vlan_id


Write-Verbose $template
Write-Verbose $networkadapter

########################
########################
# Build VM

#New-VM -Name $VM_name -VMHost sdprod01.mybofi.local -ResourcePool IT -Template $template -Datastore SDDSPROD –OSCustomizationSpec PRODServer2012_05242017
#Start-VM $VM_name 


########################
########################
# Check Completion 
#filepresent
#filenotpresent



########################
########################
# Move VM


########################
########################
# Send Completion Email
#
#

 
$head = @"
<Title>Stale Computers</Title>
<style>
Body {
font-family: "Tahoma", "Arial", "Helvetica", sans-serif;
background-color:#FFFFFF;
}
table {
border-collapse:collapse;
width:60%
}
td {
font-size:12pt;
border:1px #00008c solid;
padding:5px 5px 5px 5px;
}
th {
font-size:24pt;
text-align:left;
padding-top:5px;
padding-bottom:4px;
background-color:#00008c;
color:#ffffff;
}
name tr{
color:#000000;
background-color:#00008c;
}
</style>
"@
 
#convert output to html as a string
import-module activedirectory 
$domain = "DOMAIN.LOCAL" 
$DaysInactive = 90 
$time = (Get-Date).Adddays(-($DaysInactive))

$html = $VM_name

$paramHash = @{
 To = ""
 from = ""
 BodyAsHtml = $True
 Body = $html
 SmtpServer = "" 
 #Port = 587
 Subject = "Server Finished"
}
 
Send-MailMessage @paramHash

#}
