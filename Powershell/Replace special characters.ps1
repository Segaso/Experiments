
param ( 
  [directoryservices.directoryEntry]$root = (new-object system.directoryservices.directoryEntry), 
  [Switch]$LoadOnly 
) 

Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue
	#Date Variables
	$Date=Get-Date
	$Dshort=$Date.ToShortDateString()
	$DateCreated="Account Created: $Dshort"
	$D="{0:dd-MM-yyyy}" -f (Get-Date)
	###################
	Start-Transcript "K:\User Creation\Logs\$D.Passwords.CSV"
	$error.clear()
	###################
	Remove-PSDrive z 
	New-PSDrive -name Z -psprovider FileSystem -root \\svcfs01\'d drive' 
	###################
	
	
	
	
Function Browse-ActiveDirectory { 
  param ([directoryservices.directoryEntry]$root = (new-object system.directoryservices.directoryEntry)) 

  # Try to connect to the Domain root 

  &{trap {throw "$($_)"};[void]$Root.get_Name()} 

  # Make the form 

  $form = new-object Windows.Forms.form    
  $form.Size = new-object System.Drawing.Size @(800,600)    
  $form.text = "Active Directory Browser"   

  # Make TreeView to hold the Domain Tree 

  $TV = new-object windows.forms.TreeView 
  $TV.Location = new-object System.Drawing.Size(10,30)   
  $TV.size = new-object System.Drawing.Size(770,470)   
  $TV.Anchor = "top, left, right"     

  # Add the Button to close the form and return the selected DirectoryEntry 
  
  $btnSelect = new-object System.Windows.Forms.Button  
  $btnSelect.text = "Select" 
  $btnSelect.Location = new-object System.Drawing.Size(710,510)   
  $btnSelect.size = new-object System.Drawing.Size(70,30)   
  $btnSelect.Anchor = "Bottom, right"   

  # If Select button pressed set return value to Selected DirectoryEntry and close form 

  $btnSelect.add_Click({ 
    $script:Return = new-object system.directoryservices.directoryEntry("LDAP://$($TV.SelectedNode.text)") 
    $form.close() 
  }) 

  # Add Cancel button  

  $btnCancel = new-object System.Windows.Forms.Button  
  $btnCancel.text = "Cancel" 
  $btnCancel.Location = new-object System.Drawing.Size(630,510)   
  $btnCancel.size = new-object System.Drawing.Size(70,30)   
  $btnCancel.Anchor = "Bottom, right"   

  # If cancel button is clicked set returnvalue to $False and close form 

  $btnCancel.add_Click({$script:Return = $false ; $form.close()}) 

  # Create a TreeNode for the domain root found 

  $TNRoot = new-object System.Windows.Forms.TreeNode("Root") 
  $TNRoot.Name = $root.name 
  $TNRoot.Text = $root.distinguishedName 
  $TNRoot.tag = "NotEnumerated" 

  # First time a Node is Selected, enumerate the Children of the selected DirectoryEntry 

  $TV.add_AfterSelect({ 
    if ($this.SelectedNode.tag -eq "NotEnumerated") { 

      $de = new-object system.directoryservices.directoryEntry("LDAP://$($this.SelectedNode.text)") 

      # Add all Children found as Sub Nodes to the selected TreeNode 

      $de.get_Children() |  
      foreach { 
        $TN = new-object System.Windows.Forms.TreeNode 
        $TN.Name = $_.name 
        $TN.Text = $_.distinguishedName 
        $TN.tag = "NotEnumerated" 
        $this.SelectedNode.Nodes.Add($TN) 
      } 

      # Set tag to show this node is already enumerated 
  
      $this.SelectedNode.tag = "Enumerated" 
    } 
  }) 

  # Add the RootNode to the Treeview 

  [void]$TV.Nodes.Add($TNRoot) 

  # Add the Controls to the Form 
   
  $form.Controls.Add($TV) 
  $form.Controls.Add($btnSelect )  
  $form.Controls.Add($btnCancel ) 

  # Set the Select Button as the Default 
  
  $form.AcceptButton =  $btnSelect 
      
  $Form.Add_Shown({$form.Activate()})    
  [void]$form.showdialog()  

  # Return selected DirectoryEntry or $false as Cancel Button is Used 
  Return $script:Return 
} 
Function New-OU {							
                           if ($LoadOnly.IsPresent) { 

							  # Only load the Function for interactive use 

							  if (-not $MyInvocation.line.StartsWith('. ')) { 
								Write-Warning "LoadOnly Switch is given but you also need to 'dotsource' the script to load the function in the global scope"
								Write-Host "To Start a script in the global scope (dotsource) put a dot and a space in front of path to the script"
								Write-Host "If the script is in the current directory this would look like this :" 
								Write-Host ". .\ActiveDirectoryBrowser.Ps1" 
								Write-Host "then :" 
							  } 
							  Write-Host "The Browse-ActiveDirectory Function is loaded and can be used like this :" 
							  Write-Host '$de = Browse-ActiveDirectory' 
							  Set-alias bad Browse-ActiveDirectory 
							} 
							Else { 

						      $ldap=Browse-ActiveDirectory $root | Select-Object distinguishedname |Out-File "E:\123.txt"
                                

							} 
                           
						}

$Mod=pwd | Join-Path -ChildPath ShowUI

Import-Module $Mod

	$te=New-Window -ResizeMode NoResize -Title 'Create User' -SizeToContent WidthAndHeight -WindowStartupLocation CenterOwner -Show -On_Loaded { $FirstName.Focus() } {
		    Grid -Columns 2 -Rows 9 -Margin "8,8,8,8"   {
			    
				New-Label "First Name:" -Row 1
					New-TextBox -Name FirstName -Column 1 -Row 1 -Margin "1,1,1,1"
					
			    New-Label "Last Name:" -Row 2 
					New-TextBox -Name LastName -column 1 -Row 2 -Margin "1,1,1,1"
					
			    New-Label "Personal Email:" -Row 3 -Column 0
					New-TextBox -Name Pemail -Column 1 -Row 3 -Margin "1,1,1,1"
					
                New-Label "Student/Emp. ID" -Row 4 -Column 0
					New-TextBox -Name ID -Column 1 -Row 4 -Margin "1,1,1,1"
						
			    New-Label "Dept. (Copiers):" -row 5
			    New-ComboBox -Width 150 -row 5 -column 1 -IsTextSearchEnabled:$true -MaxDropDownHeight 100 -Name Departments -Margin "1,1,1,1" -SelectedIndex 0 {
						New-ComboBoxItem "Student"
                        New-Comboboxitem "Academic Support (Donna)"
						New-Comboboxitem "Accreditation"
						New-Comboboxitem "Admissions"
						New-Comboboxitem "Alumni"
						New-Comboboxitem "Athletics Administration"
						New-Comboboxitem "Audit"
						New-Comboboxitem "Baseball"
						New-Comboboxitem "Board of Trustee's"
						New-Comboboxitem "Bowling"
						New-Comboboxitem "Boy's Basketball Camp"
						New-Comboboxitem "Business Division"
						New-Comboboxitem "Business Office"
						New-Comboboxitem "Campus Dinner Project"
						New-Comboboxitem "Campus Life"
						New-Comboboxitem "Campus Store"
						New-Comboboxitem "Career Services"
						New-Comboboxitem "Civic Engagement"
						New-Comboboxitem "Commencement"
						New-Comboboxitem "Counseling"
						New-Comboboxitem "Cross Country"
						New-Comboboxitem "Development"
						New-Comboboxitem "Events"
						New-Comboboxitem "Facilities"
						New-Comboboxitem "Federal Success Center"
						New-Comboboxitem "Financial Aid"
						New-Comboboxitem "Girl's Basketball Camp"
						New-Comboboxitem "Health Care Mgmt Advocacy"
						New-Comboboxitem "Health Services"
						New-Comboboxitem "Homecoming"
						New-Comboboxitem "Humanities"
						New-Comboboxitem "IT"
						New-Comboboxitem "Jazzman"
						New-Comboboxitem "Legal"
						New-Comboboxitem "Library"
						New-Comboboxitem "Mailroom"
						New-Comboboxitem "Maintenance"
						New-Comboboxitem "Men's Basketball"
						New-Comboboxitem "Men's Soccer"
						New-Comboboxitem "Men's Volleyball"
						New-Comboboxitem "Nursing Division"
						New-Comboboxitem "Orientation"
						New-Comboboxitem "Personnel"
						New-Comboboxitem "Pipeline Project"
						New-Comboboxitem "President's Office"
						New-Comboboxitem "Provost/Adjunct Faculty"
						New-Comboboxitem "Public Relations"
						New-Comboboxitem "Quest for Success"
						New-Comboboxitem "Radiologic Technology"
						New-Comboboxitem "Registrar"
						New-Comboboxitem "Residential Life"
						New-Comboboxitem "Science & Technology"
						New-Comboboxitem "Security"
						New-Comboboxitem "Snack Bar"
						New-Comboboxitem "Soccer Camp"
						New-Comboboxitem "Social Sciences Division"
						New-Comboboxitem "Softball"
						New-Comboboxitem "Student Affairs/Dean of Students"
						New-Comboboxitem "Student Government Assoc"
						New-Comboboxitem "Summer Programs"
						New-Comboboxitem "SVC Success Center"
						New-Comboboxitem "Transportation - Bus"
						New-Comboboxitem "Transportation - Van"
						New-Comboboxitem "Upward Bound"
						New-Comboboxitem "Women's Basketball"
						New-Comboboxitem "Women's Soccer"
						New-Comboboxitem "Women's Volleyball"
                        }
                    New-Label -Name OU -Column 0 -Row 6 "Orginazitional Unit:"
                        New-Button "Browse" -Name OU  -column 1 -row 6 -Margin "1,3,1,3" -On_Click {New-OU}
                       
			    New-Label "Group:" -Row 7 -Column 0
		            New-UniformGrid -Columns 2 -Rows 2 -Margin "8,8,8,8" -Column 1 -Row 7 {
			            New-CheckBox -Name Student 'Student' -Row 1 -Column 1
			            New-CheckBox -Name Faculty 'Faculty' -Row 2 -Column 2
			            New-CheckBox -Name Staff 'Staff' -Row 1 -Column 1
			            New-CheckBox -Name Administrative 'Admin.' -Row 2 -Column 2
		}
		New-Button "Create" -Width 90 -Height 30 -column 0 -row 9 -On_Click {
          
            $parent| Set-UIValue -passThru | Close-Control
			}
		New-Button "Close" -Width 90 -Height 30 -column 1 -row 9 -On_Click {
			Close-Control
			exit
			}
		} 
	} 
	


   
$OU=(Get-Content "E:\123.txt")[3] -replace "}\s+" -replace "{"
$OU1=@{"OU"="$OU"}
$Total=$te+$OU1
Remove-Item "E:\123.txt"
$Department=$Total.Get_Item("Departments") `
        -replace "Academic Support (Donna)","111004" -replace "Accreditation","118204" -replace "Admissions","111301" `
        -replace "Alumni","119101" -replace "Athletics Administration","111201" -replace "Audit","118203"  `
        -replace "Baseball","111207" -replace "Board of Trustee's","118208" -replace "Bowling","111214" `
        -replace "Boy's Basketball Camp","112104" -replace "Business Division","111005" -replace "Business Office","118003" `
        -replace "Campus Dinner Project","128233" -replace "Campus Life","111110" -replace "Campus Store","114000" `
        -replace "Career Services","111102" -replace "Civic Engagement","111103" -replace "Commencement","111030" `
        -replace "Counseling","111112" -replace "Cross Country","111208" -replace "Development","119100" `
        -replace "Events","112101" -replace "Facilities","118101" -replace "Federal Success Center","121116" `
        -replace "Financial Aid","118005" -replace "Girl's Basketball Camp","112105" -replace "Health Care Mgmt Advocacy","111015" `
        -replace "Health Services","111105" -replace "Homecoming","119302" -replace "Humanities","111006" `
        -replace "IT","118002" -replace "Jazzman","114101" -replace "Legal","118202" `
        -replace "Library","111019" -replace "Mailroom","118006" -replace "Maintenance","118102" `
        -replace "Men's Basketball","111205" -replace "Men's Soccer","111203" -replace "Men's Volleyball","111211" `
        -replace "Nursing Division","111002" -replace "Orientation","111120" -replace "Personnel","118206" `
        -replace "Pipeline Project","128234" -replace "President's Office","118201" -replace "Provost/Adjunct Faculty","111001" `
        -replace "Public Relations","111401" -replace "Quest for Success","111012" -replace "Radiologic Technology","111011" `
        -replace "Registrar","111020" -replace "Residential Life","111111" -replace "Science & Technology","111007" `
        -replace "Security","111107" -replace "Snack Bar","114102" -replace "Soccer Camp","111206" `
        -replace "Social Sciences Division","111008" -replace "Softball","111206" -replace "Student Affairs/Dean of Students","111101" `
        -replace "Student Government Assoc","111106" -replace "Summer Programs","112102" -replace "SVC Success Center","111115" `
        -replace "Transportation - Bus","111108" -replace "Transportation - Van","111109" -replace "Upward Bound","121117" `
        -replace "Women's Basketball","111204" -replace "Women's Soccer","111202" -replace "Women's Volleyball","111210" 

$Fi=$Total.Get_Item("FirstName")
$La=$Total.Get_Item("LastName")
$PersonalEmail=$Total.Get_Item("Pemail")
$GStudent=$Total.Get_Item("Student")
$GAdmin=$Total.Get_Item("Administrative")
$GStaff=$Total.Get_Item("Staff")
$GFaculty=$Total.Get_Item("Faculty")
$employeeID=$Total.Get_Item("ID")
$Container=$Total.Get_Item("OU")

	$Password=@()
    $Member=$null
    $Member2=$null
	$DCheck=$null
	
    $Domain='@svc.local'
	
	#Used for Fowarding Exchange to Google Apps 
	$OldEmail='@svc.edu'
	$NewEmail='@new.svc.edu'
	############################################
	$Lscript='logon.bat'
	$smtpserver="10.10.0.4"
	$fromAddress='it@svc.edu'
	#Creating Share Variables
	$Drive='J:'
	$FileServer='SVCFS01'



Function Create-Users {
	IF (Get-QADUser -Firstname $Fi -LastName $La) {
			$DCheck=Get-QADUser -Firstname $Fi -LastName $La | ft firstname,lastname,userprincipalname -auto | out-string
				$TLO=1
			}
			Else {
				$FillerVariable="ddfkdsf"
			}
			
			IF ($TLO -eq 1) {
				Write-Warning "User already in active directory. Script may create duplicate"
				$DCheck
				$title = "Check Active Directory to see if the user or users already exist"
				$message = "Do you want to Continue the script?"

				$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
					"Continues the Script."

				$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
					"Ends the Script."

				$restart = New-Object System.Management.Automation.Host.ChoiceDescription "&Restart", `
					"Restarts the Script."

				$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $restart)

				$result = $host.ui.PromptForChoice($title, $message, $options, 1) 

					switch ($result)
						{
							0 {
								Write-Host "Continuing the Script!"
							}
							1 {
								exit
							}
							2 {
								Create-Users
							}
						}
			}
			ELSE {
				$FillerVariable="ddfkdsf"
				}
				
	$i=1
	#########################################

			$First=$Fi `
                     -replace "\s+" -replace "," -replace "'" `
                     -replace "!" -replace ">" -replace "<" `
                     -replace "/" -replace "\*" -replace "\\" `
                     -replace '\"' -replace "\?" -replace "\."

			$Last=$La `
                     -replace "\s+" -replace "," -replace "'" `
                     -replace "!" -replace ">" -replace "<" `
                     -replace "/" -replace "\*" -replace "\\" `
                     -replace '\"' -replace "\?" -replace "\."  
			$Username=$First.substring(0,1)+$Last
	#########################################	
			IF (Get-QADUser $Username) {
				do {
					$Username=$Username+$i++; 
				   }
				while (get-QADuser $Username)
			}
			ELSE {
				$Username=$First.substring(0,1)+$Last
			}
		Clear-Variable -Name i
	#########################################
		$UPN=$Username+$Domain
		$Name=$Fi+" "+$La
		$Display=$La+" "+$Fi
		$PPath='\\SVCFS01\Profiles$\'+$Username
		$Email=$Username+$OldEmail
		$Duplicate="svc.local/Duplicates"
	############################################
		##Exchange Variables
		$legacy="/o=SouthernVermontCollege/ou=First Administrative Group/cn=Recipients/cn=$Username"
		$Gmail=$Username+$NewEmail
		$Email=$Username+$OldEmail
		$TAddress="SMTP:$Gmail"
		$Proxy1="SMTP:$Email"
		$Proxy2="smtp:$Gmail"
	############################################
		#Share Variables
		$temp=$Username+"$"
		$HDirectory="\\SVCFS01\"+$temp
		$sharepath="D:\Users\$Username"
	############################################
		$AuthUser="$Dom$Username"
		$SPer="SYSTEM"
		$DPer="$domwin"+"Domain Admins"
		$SAdmin="$domwin"+"Administrator"
		
	############################################
	##Profile Folder Permissions
		$vista=$Username+".V2"
	############################################
			##Create Password
			$rand = New-Object System.Random
			1..10 | ForEach { $NewPassword = $NewPassword + [char]((Get-Random -Minimum 65 -Maximum 91) + (Get-Random -Maximum 2)*32) };
			$Userpassword=$NewPassword
			Clear-Variable NewPassword
		############################################
			$obj = New-Object -TypeName PSObject
			$obj | Add-Member -MemberType NoteProperty -name 'Usernames' -value $Username
			$obj | Add-Member -MemberType NoteProperty -name 'Passwords' -value $Userpassword
				$Password += $obj
		############################################
			try {	
					NEW-QADUSER -FirstName $Fi -LastName $La -Department $Department -DisplayName $Display -Name $Display -SamAccountName $Username -UserPassword $Userpassword -UserPrincipalName $Username -ParentContainer $Container -ProfilePath $PPath -Email $NEmail -LogonScript $Lscript -HomeDrive $Drive -HomeDirectory $HDirectory -Description $DateCreated -ObjectAttributes @{msExchALObjectVersion='61';employeeID=$employeeID;targetAddress=$TAddress;legacyExchangeDN=$legacy;mailNickname=$Username;persoanlEmailAddress=$PersonalEmail;} -ErrorAction "Stop"
					}
			catch {
					NEW-QADUSER -FirstName $Fi -LastName $La -Department $Department -DisplayName $Display -Name $Display -SamAccountName $Username -UserPassword $Userpassword -UserPrincipalName $Username -ParentContainer $Duplicate -ProfilePath $PPath -Email $NEmail -LogonScript $Lscript -HomeDrive $Drive -HomeDirectory $HDirectory -Description $DateCreated -ObjectAttributes @{msExchALObjectVersion='61';employeeID=$employeeID;targetAddress=$TAddress;legacyExchangeDN=$legacy;mailNickname=$Username;persoanlEmailAddress=$PersonalEmail;} 	
					}
					
			Get-QADUser $Username |
					Add-QADProxyAddress -Address $Proxy2 |
					Add-QADProxyAddress -Address $Proxy1 -Primary |
					Add-QADProxyAddress -CustomType "X400" -Address "c=us;a= ;p=SouthernVermontC;o=Exchange;s=$LName;g=$Fi;" 
			
		############################################
				$MStudent="SVC Students"
				$MStaff="SVC Staff"
				$MFaculty="SVC Faculty"
				$MAdmin="SVC Administrative"

				If (($GStudent -eq $True) -and ($GStaff -eq $False) -and ($GAdmin -eq $False) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $True) -and ($GAdmin -eq $False) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $False) -and ($GAdmin -eq $True) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $False) -and ($GAdmin -eq $True) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $True) -and ($GAdmin -eq $True) -and ($GFaculty -eq $True)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local" 
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local" 
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $True) -and ($GAdmin -eq $True) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local"
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $False) -and ($GAdmin -eq $True) -and ($GFaculty -eq $True)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"							
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $True) -and ($GAdmin -eq $False) -and ($GFaculty -eq $True)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"
					}
				elseif (($GStudent -eq $False) -and ($GStaff -eq $True) -and ($GAdmin -eq $True) -and ($GFaculty -eq $True)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"					
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $True) -and ($GAdmin -eq $True) -and ($GFaculty -eq $False)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local"					
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $False) -and ($GAdmin -eq $True) -and ($GFaculty -eq $True)) {
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"					
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $True) -and ($GAdmin -eq $False) -and ($GFaculty -eq $True)) { 
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"					
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local" 
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $False) -and ($GAdmin -eq $True) -and ($GFaculty -eq $False)) { 
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MAdmin,OU=Security Groups,DC=svc,DC=local"
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $True) -and ($GAdmin -eq $False) -and ($GFaculty -eq $False)) { 
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MStaff,OU=Security Groups,DC=svc,DC=local"
					}
				elseif (($GStudent -eq $True) -and ($GStaff -eq $False) -and ($GAdmin -eq $False) -and ($GFaculty -eq $True)) { 
					Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local"
					Add-QADGroupMember -Member $Username -Identity "CN=$MFaculty,OU=Security Groups,DC=svc,DC=local"
					}
				else {
						Add-QADGroupMember -Member $Username -Identity "CN=$MStudent,OU=Security Groups,DC=svc,DC=local" 
				}
	############################################
					##Create Share	
					#The directory D:\Users needs to be shared with the Z: drive letter
					#New-Item dislikes UNC paths, but drive letters seems to do the trick
					
					New-Item -path "Z:\Users\$Username","Z:\User Profiles\$Username","Z:\User Profiles\$vista" -type Directory
					
					############################################################################################
					$acl=Get-Acl -path "Z:\User Profiles\$Username"
					$acl.SetAccessRuleProtection($True,$False)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("svc.local\$Username","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BAssist","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Administrator","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					Set-Acl "Z:\User Profiles\$Username" $acl
					
					############################################################################################
					$acl=Get-Acl -path "Z:\User Profiles\$vista"
					$acl.SetAccessRuleProtection($True,$False)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("svc.local\$Username","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BAssist","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Administrator","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					Set-Acl "Z:\User Profiles\$vista" $acl
					
					############################################################################################
					$acl=Get-Acl -path "Z:\Users\$Username"
					$acl.SetAccessRuleProtection($True,$False)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Domain Admins","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("svc.local\$Username","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("svc.local\ServiceVeritas","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("SVCWIN\Administrator","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
					$acl.AddAccessRule($rule)
					Set-Acl "Z:\Users\$Username" $acl
############################################################################################
##Here-strings really dislike tabs or spaces
$Body=@"
Dear $Name,

Welcome to Southern Vermont College. This email is to inform you of your new Southern Vermont College (SVC) user name and password.

SVC email is the official method of communication between administrators, staff, faculty, and students. All employees and students are expected to check their SVC email regularly.

Your SVC user name is: "$Username"
Your email address is: "$Email"
Your password is: "$Userpassword"

Please be aware that while your SVC user name and email address are not case-sensitive, your password IS case sensitive.

You can access your email account directly by visiting http://gmail.svc.edu  or you can use the links found on the left column of the SVC home page.

Your SVC user name and password are also used when you wish to log into Moodle which is a web-based course resource tool that will be explained in detail by your instructors. The login page for Moodle is http://moodle.svc.edu.

Your SVC user name and password are also used when you wish to log into a Windows computer in one of the SVC campus Computer Labs.

If you wish to change your password, visit http://webmail.svc.edu/password. If you have any problems, call us and we can reset your password over the phone.

Please note that your SVC user name and password are NOT currently used for the e2campus Emergency Notification System or the SVC Scholar Portal where you register for classes and check your grades.  Those systems are independent and have their own login systems, at least for now. Detailed information can be found on the IT department web site at http://it.svc.edu.

If you have questions you can contact the IT department at ext. 6344 or 802-447-6344 or by email to it@svc.edu.

We look forward to addressing your on-campus technology needs.

Sincerely,
Michael Keen
Director of Information Technology
802-447-6344
http://it.svc.edu 
"@
############################################################################################

			Send-MailMessage -smtpserver $smtpserver -From "SVC IT Dept <$fromAddress>" -To $PersonalEmail -Bcc mkeen@svc.edu -Subject "Welcome to your SVC email account" -Body $Body 
		
############################################################################################

############################################################################################
		
		}
}
############################################################################################
################################Time to actually call the Function##########################		
############################################################################################

	Create-Users

##Log Creation
	Get-QADUser -Description $DateCreated | Select-Object DisplayName,UserPrincipalName,Description | Export-CSV "K:\User Creation\Logs\$D.csv" -NoTypeInformation
			
	$Password | Export-CSV "K:\User Creation\Logs\$D.Passwords.CSV" -NoTypeInformation	
	
	IF ($error -eq $null) {
		Write-Host "No errors were encountered"
	}
	ELSE {
		Write-Warning "Errors encountered log file Errorlog.$D.txt was created"
		$error | Out-File "K:\User Creation\Logs\Errorlog.$D.txt"
	}
	Stop-Transcript 
	############################################
	##Creat Shares##
		##Invoke-Command -Computername SVCFS01 -FilePath "C:\Shares.ps1" | Out-File "K:\User Creation\Logs\Sharelog.$D.txt"
	#############################################
		Write-Host "Press any key to continue ..."
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
				
