cls
$dt = get-date
[datetime]$cdt = '6/12/2016'

if ($cdt -gt $dt){
write-host 'invalid date'
}