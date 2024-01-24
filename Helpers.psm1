function SendEmail {
    param([string]$to, [string]$cc, [string]$from, [string]$subject, [string]$body,[bool]$isImportant=$false)
    try {
        $smtpServer = "smtp.ravibaghel.com" 
        $mailer = new-object Net.Mail.SMTPclient($smtpserver)              
        $msg = new-object Net.Mail.MailMessage
        $msg.From = $from
        foreach ($email in $to.Split(',')) {
            $msg.To.add($email)
        }
        if ($cc) {
            foreach ($email in $cc.Split(',')) {
                $msg.CC.add($email)
            }
        }
        $msg.Subject = $subject
        $msg.Body = $body   
        $msg.IsBodyHTML = $true
        if($isImportant){$msg.Priority = [System.Net.Mail.MailPriority]::High}
        $mailer.send($msg)
    }
    
    finally {
        $msg.Dispose()
        $mailer.Dispose()
    }
}

#https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0
function Write-Log {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [Alias('LogPath')]
        [string]$Path = 'Log.log',
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Error", "Warn", "Info")]
        [string]$Level = "Info",
        
        [Parameter(Mandatory = $false)]
        [switch]$NoClobber
    )

    Begin {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = 'Continue'
    }
    Process {
        
        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
        }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
        }

        else {
            # Nothing to see here yet.
        }

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
            }
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
            }
            'Info' {
                Write-Verbose $Message
                $LevelText = 'INFO:'
            }
        }
        
        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End {
    }
}