while(1 -lt 10){

$a = Get-WmiObject -Class Win32_PerfRawData_PerfProc_Process

$oggetto = @()

foreach($processo in $a){
    if($processo.Name -match "_TOTAL"){
        $memo_tot = [math]::round($processo.WorkingSetPrivate / 1Mb, 3)
        $disk_tot = [math]::round($processo.IODataBytesPersec / 1Mb, 3)
    }
}

foreach ($proc in $a){
    if($proc.Name -notmatch "_TOTAL"){
    $mem = [math]::round($proc.WorkingSetPrivate / 1Mb, 3)
    $disk = [math]::round($proc.IODataBytesPersec / 1Mb, 3)
    $data = Get-Date -UFormat "%d-%m-%Y_%T"
    
    $mem_perc = [math]::round(($mem/$memo_tot)*100,3)
    $disk_perc = [math]::round(($disk/$disk_tot)*100,3)

    if ($mem_perc -gt 5 -or $disk_perc -gt 5){
       
       $obj = New-Object System.Object
       $obj | Add-Member -Type NoteProperty -Name Nome -Value $proc.Name
       $obj | Add-Member -Type NoteProperty -Name PID -Value $proc.IDProcess
       $obj | Add-Member -Type NoteProperty -Name RAM_MB -Value $mem
       $obj | Add-Member -Type NoteProperty -Name Disco+Network_MB/s -Value $disk
       $obj | Add-Member -Type NoteProperty -Name RAM_% -Value $mem_perc
       $obj | Add-Member -Type NoteProperty -Name Disco+Network_% -Value $disk_perc
       $obj | Add-Member -Type NoteProperty -Name Data_Ora -Value $data
       
       $oggetto += $obj

       }
    }

}

$oggetto | Export-Csv -Path "c:\tmp\processi.csv" -Append

Start-Sleep -Seconds 6

}