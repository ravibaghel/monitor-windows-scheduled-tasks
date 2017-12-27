param(
[string]$tasknametocheck = "WO Matrix Export"
)
$head=""
$Date = Get-Date -Format "MM/dd/yyyy"  
$b = "<H2>WOT Local TV QA $tasknametocheck status from $Date</H2>" 
$task_info = Get-ScheduledTask -TaskName $tasknametocheck | Get-ScheduledTaskInfo
$body = $task_info | select TaskName, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns | convertto-html -head $head -body $b                 
If ($task_info.LastTaskResult -eq 0) {       
	$subject = "$tasknametocheck Scheduled Task Success" 
} else {
	$subject = "$tasknametocheck Scheduled Task Failure" 
}
$smtpServer = "smtp.server" 
$mailer = new-object Net.Mail.SMTPclient($smtpserver)              
$From = "no-reply@ravibaghel.com" 
$To = "demo@ravibaghel.com" 
$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)   
$msg.IsBodyHTML = $true 
$mailer.send($msg)