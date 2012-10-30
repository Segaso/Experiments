<#
Sign Powershell Script(s)

First you need to create the Certificate to be able to sign your script. The two commands below will create one certificate in Trusted CA and another in Personal.

makecert -n "CN=PowerShell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine

makecert -pe -n "CN=PowerShell User" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer#
Set-AuthenticodeSignature <Insert Path Here> @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
Needs to  be ran in Single-Thread (powershell -sta), or copied/ran in Powershell ISE.
#>
$end=0
$MultipleScripts=$Null
$ScriptName=$Null


##Single Script
Function Get-FileName($initialDirectory) {   
		[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

			 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
			 $OpenFileDialog.initialDirectory = $initialDirectory
			 $OpenFileDialog.filter = "All files (*.*)| *.*"
			 $OpenFileDialog.ShowDialog() | Out-Null
			 $OpenFileDialog.filename
	}
###########################################################

##A Module or something with a lot of powershell scripts in one folder
function Select-Folder($message='Select ', $path = 0) { 
    $object = New-Object -comObject Shell.Application  
     
    $folder = $object.BrowseForFolder(0, $message, 0, $path) 
    if ($folder -ne $null) { 
        $folder.self.Path 
    } 
}
###########################################################
            While ($end -ne 1) {
				$title = "Sign Script(s) with Self-Signed Cert."
				$message = "Select an Option"

				$Single = New-Object System.Management.Automation.Host.ChoiceDescription "&Single", `
					"Sign One Script."

				$Multiple = New-Object System.Management.Automation.Host.ChoiceDescription "&Multiple", `
					"Sign Multiple Scripts."

				$Exit = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
					"Time to Jet."

				$options = [System.Management.Automation.Host.ChoiceDescription[]]($Single, $Multiple, $Exit)

				$result = $host.ui.PromptForChoice($title, $message, $options, 2) 
                
					switch ($result)
						{
							0 {
								 $ScriptName=Get-FileName -initialDirectory "C:"
                                 Set-AuthenticodeSignature $ScriptName @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
    							}
							1 {
								$SelectedModule=Select-Folder 
								$MultipleScripts=Get-ChildItem $SelectedModule -Recurse -Include *.ps1,*.psm1,*.psd1,*.ps1xml | foreach-object -process { $_.FullName }
                                    FOREACH ($Script in $MultipleScripts) {
                                         Set-AuthenticodeSignature $Script @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
									}

							}
							2 {
                                $end=1
                                Write-Host "Press any key to continue ..."
		                        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
								exit
							}
						}
            }
###########################################################
			