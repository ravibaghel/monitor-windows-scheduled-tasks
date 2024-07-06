# Monitor Windows Task Scheduler

This project aims to provide a monitoring solution for Windows Task Scheduler. It allows users to track the execution status of scheduled tasks, view their logs, and receive notifications in case of failures. By monitoring the Task Scheduler, users can ensure the smooth operation of their scheduled tasks and promptly address any issues that may arise.

# check_task_scheduler.ps1

This PowerShell script is used to monitor the status of scheduled tasks on multiple servers. It reads a configuration file (`config.json`), checks the status of each job on each server, and sends email notifications if a job is in an error state or disabled.

## Parameters

- `Environment`: A string that specifies the environment. Default is "[DEV]".

## Usage

1. Open PowerShell.

2. Navigate to the directory where the `check_task_scheduler.ps1` script is located.

3. Run the script with the following command:

```powershell
.\check_task_scheduler.ps1 -Environment "[YourEnvironment]"

Sure, here's a markdown documentation for the `check_task_scheduler.ps1` script:

```markdown
# check_task_scheduler.ps1

This PowerShell script is used to monitor the status of scheduled tasks on multiple servers. It reads a configuration file (`config.json`), checks the status of each job on each server, and sends email notifications if a job is in an error state or disabled.

## Parameters

- `Environment`: A string that specifies the environment. Default is "[DEV]".

## Usage

1. Open PowerShell.

2. Navigate to the directory where the `check_task_scheduler.ps1` script is located.

3. Run the script with the following command:

```powershell
.\check_task_scheduler.ps1 -Environment "[YourEnvironment]"
```

Replace `[YourEnvironment]` with your actual environment.

## Notes

- The script imports a module named `Helpers.psm1`. Make sure this module is in the same directory as the script.

- The script reads a `config.json` file which should contain the servers and jobs to be monitored. Make sure this file is in the same directory as the script.

- The script writes logs to a `Logs` directory. This directory should be in the same location as the script.

- The script sends email notifications if a job is in an error state or disabled. Make sure to configure the email settings in the `config.json` file.

- The script deletes logs that are older than 7 days.

- If an error occurs while running the script, it logs the error and sends an email notification.
```

Please replace the placeholders and instructions with the actual values and instructions specific to your setup.