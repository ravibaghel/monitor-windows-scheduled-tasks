param(
	[String]$Environment = "[DEV]"
)
$ErrorActionPreference = "Stop"
Import-Module ".\Helpers.psm1"
$date = get-date -format yyyy-MM-dd
$logPath = ".\Logs\log-$date.log"
$CurrentDate = Get-Date
try {
	$servers = Get-Content .\config.json | ConvertFrom-Json
	foreach ($server in $servers) {
		$Environment = $server.Environment
		foreach ($job in $server.Jobs) {
			$result = (Get-ScheduledTaskInfo -CimSession $server.Server -TaskName $job.Name).LastTaskResult
			$state = (Get-ScheduledTask -CimSession $server.Server -TaskName $job.Name).State
			Write-Log -Message "Job name is  $($job). Result is $($result)" -Level Info -Path $logPath
			Write-Log -Message "Job name is  $($job). State is $($state)" -Level Info -Path $logPath
			if (0, 267014 -notcontains $result) {
				$sendNotification = $true
				switch (267009) {
					267009 {
						if ([bool]($job.PSobject.Properties.name -match "Script")) {
							$sendNotification = & ("{0}\Scripts\{1}" -f $PSScriptRoot, $job.Script)
						}
						else {
							$sendNotification = $false
						}; Break}
					Default {
						if ([bool]($job.PSobject.Properties.name -match "Script")) {
							$sendNotification = & ("{0}\Scripts\{1}" -f $PSScriptRoot, $job.Script)
						}
					}
				}
				$email_subject = "{0} - {1} job is having an error on {2} server - {3}" -f $Environment, $job.Name , $server.Server, $CurrentDate
				$email_body = "{0} - {1} job is having an error {2} on {3} server. Please take action or remove it from config if no longer needed for monitoring. <BR/> Thank you" -f $Environment, $job.Name, $result , $server.Server
				$sendNotification
				if ($sendNotification) {
					SendEmail -To $server.To -Cc $server.Cc -From $server.From -Subject $email_subject -Body $email_body -IsImportant $true
					Write-Log -Message ("Email notification sent for job {0}" -f $job.Name) -Level Info -Path $logPath
				}
			}
			if ($state -eq "disabled") {
				$email_subject = "{0} - {1} job is disabled on {2} server - {3}" -f $Environment, $job.Name , $server.Server, $CurrentDate
				$email_body = "{0} - {1} job is disabled on {2} server. Please take action or remove it from config if no longer needed for monitoring. <BR/> Thank you" -f $Environment, $job.Name , $server.Server
				SendEmail -To $server.To -Cc $server.Cc -From $server.From -Subject $email_subject -Body $email_body -IsImportant $true
				Write-Log -Message ("Email notification sent for job {0}" -f $job.Name) -Level Info -Path $logPath
			}
		}
	}
}
catch {
	if ($Error.Count -gt 0) {
		Write-Log -Message "Error $($Error)" -Level Error -Path $logPath
		$email_body = "<H2>Please review the error in generating report $($error)<br>Thank you"
		$email_subject = "Error in check task scheduler script"
		SendEmail -To "ravibaghel@ravibaghel.com" -From "no-reply@ravibaghel.com" -Subject $email_subject -Body $email_body
	}
	else {
		Write-Log -Message "Somethig wierd happen" -Level Error -Path $logPath
	}
}
finally {
	$Daysback = "-7"
	$CurrentLogDate = Get-Date
	$DatetoDeleteLog = $CurrentLogDate.AddDays($Daysback)
	Get-ChildItem ".\Logs\" | Where-Object { $_.LastWriteTime -lt $DatetoDeleteLog } | Remove-Item
	Write-Log "Job Completed" -Path $logPath
}