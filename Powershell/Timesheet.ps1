	$Timesheet=Import-CSV C:\Timesheet.csv
	$Money=Read-Host "Enter money earned per hour"
	$ErrorActionPreference="SilentlyContinue"

	FOREACH($Time in $Timesheet){

		$Hours=New-Timespan $(Get-Date $Time.Start) $(Get-Date $Time.End)
		$OTHours=New-Timespan $(Get-Date $Time.OTStart) $(Get-Date $Time.OTEnd)
		
		$HTotal=$Hours.Totalhours+$OTHours.TotalHours
			$HoursT +=$HTotal
	}
            $Total=[Math]::Floor($Hourst)
            $Minutes=$Hourst - $Total
            $MinutesTotal=[Math]::Round(($Minutes*100)*.6)
            $MT=(($Minutes*100)*.6)
            $MoneyTotal=(($Total+($MT*(1/100)))*$Money)
            
			echo "Hours Total    :  $Total"
            echo "Minutes Total  :  $MinutesTotal"
            echo "Gross Total    :  $MoneyTotal"
			echo "After Uncle Sam:  $Tax"
			
			
            Write-Host "Press any key to continue ..."

			$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

