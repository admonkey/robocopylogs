$backup_drive_letter = "E:"
$dir_robocopy_log = "C:\NetworkShares\Downloads\robocopylogs"
$path_web = "http://media.puck.work/Downloads/robocopylogs/"

# delete old includes
echo " " | Out-File -Encoding "ASCII" $dir_robocopy_log\NetworkShares.inc
echo " " | Out-File -Encoding "ASCII" $dir_robocopy_log\MediaArchive.inc
echo " " | Out-File -Encoding "ASCII" $dir_robocopy_log\robocopylogs.inc

$date1 = Get-Date -Date "01/01/1970"
$date2 = Get-Date
$time_start = (New-TimeSpan -Start $date1 -End $date2.ToUniversalTime()).TotalSeconds
"<?php
    `$running_status = 'Started';
    `$time_start = $time_start;
?>" | Out-File -Encoding "ASCII" $dir_robocopy_log\status.inc.php;

#Stop-VM -Name Popcorn -TurnOff

echo "<h2>NetworkShares</h2><p>" (date) "</p>" | Out-File -Encoding "ASCII" $dir_robocopy_log\NetworkShares.inc
robocopy C:\NetworkShares $backup_drive_letter\NetworkShares /MIR /Z /v /x /LOG:$dir_robocopy_log\NetworkShares-backup.log /XA:SH /XJD /XF *.bin /XD C:\NetworkShares\charlie $dir_robocopy_log

echo "<h2>MediaArchive</h2><p>" (date) "</p>" | Out-File -Encoding "ASCII" $dir_robocopy_log\MediaArchive.inc
robocopy M:\MediaArchive $backup_drive_letter\MediaArchive /MIR /Z /v /x /LOG:$dir_robocopy_log\MediaArchive-backup.log /XA:SH /XJD /XF *.bin

echo "<h2>robocopylogs</h2><p>" (date) "</p>" | Out-File -Encoding "ASCII" $dir_robocopy_log\robocopylogs.inc
robocopy $dir_robocopy_log $backup_drive_letter\robocopylogs /MIR /Z /XA:SH /XJD

#Start-VM -Name Popcorn

$date_complete = Get-Date
$time_complete = (New-TimeSpan -Start $date1 -End $date_complete.ToUniversalTime()).TotalSeconds
"<?php
    `$running_status = 'Complete';
    `$time_start = $time_start;
    `$time_complete = $time_complete;
?>" | Out-File -Encoding "ASCII" $dir_robocopy_log\status.inc.php;

logoff; exit
