clear-host
$today_date = get-date
$monthdt = $today_date.Month
$daydt = $today_date.day
$code = read-host -prompt 'Enter code'
$varsfile = 'C:\PSHELL\pw'+$code+'.txt'
$strPassword ="house"
$strQuit = "Guess again"
Do {
    write-host '1.   search'
    write-host '2.   add'
    write-host '3.   delete'
    write-host '4.   edit'
    write-host '5.   exit'
    $Guess = Read-Host "`n Guess the Password"
    if($Guess -eq $StrPassword) {
        " Correct guess"; $strQuit ="n"
    }
    else{
        $strQuit = Read-Host " Wrong `n Do you want another guess? (Y/N)"
    }
} 
While ($strQuit -ne "N")

1:
$sel = read-host -prompt 'enter selection#'
if ($sel -eq '5'){exit} 
$recs = get-content $varsfile
$array_recs = $recs[0].split(']')
$s1 = $recs | Select-Object -first 1
if ($s1 -match $code) {
    $textsearch = read-host -prompt 'Enter text to search'
    if ($textsearch -ne $null){
             $counter = 1
             ForEach-Object { 
                if ($recs[$counter] -match $textsearch) { ($recs[$counter].split(']'))[1]}
                $counter=$counter + 1
                
        }
      
    }
} else {exit}
