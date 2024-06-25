$mypath = Split-Path -Path $MyInvocation.MyCommand.Path
$myDrive = $mypath.Substring(0, 2)
$sessionPath = "${myDrive}\AximmetrySessionData"	# path to the folder where the session files are stored

$companionURL = "http://127.0.0.1:9000"	# URL of the companion instance

# define variables
$dataFile = "$sessionPath\media\" + $args[1] + "\" + $args[1] + ".txt"
$imagePath = "$sessionPath\media\" + $args[1] + "\"

$lines = Get-Content $datafile
$counter = 0
$bank = 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 18, 19
$rows = 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2
$cols = 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2
$page = $args[0]

$osc_message = ""  # here we will assemble the message required to create the new files.

foreach ($line in $lines) {
	if ( ($counter + 1) -gt 16) {
		break
	}
	$split = $line.Split(';')
	$osc_message = $osc_message + '  "' + $imagePath + $split[1] + '"'
	# first we change the names of the buttons. one by one.
	$request = "${companionURL}/api/location/" + $page + "/" + $rows[$counter] + "/" + $cols[$counter] + "/style?bgcolor=%00000000&size=7&text=" + $split[0]
	Invoke-WebRequest -Uri $request -Method 'POST' | Out-Null
	$counter += 1
}
# empty buttons for the rest of the bank
for ($i = $counter; $i -lt 16; $i++) {
	$osc_message = $osc_message + '  "" '
	$request = "${companionURL}/api/location/" + $page + "/" + $rows[$i] + "/" + $cols[$i] + "/?bgcolor=%00000000&size=7&text=" + "empty"
	Invoke-WebRequest -Uri $request -Method 'POST' | Out-Null
}

# create the message that needs to be sent by osc to aximmetry to change the filenames.
$urlCustomVariable = "${companionURL}/api/custom-variable/" + "temp/value?value=" + $osc_message
Invoke-WebRequest -Uri $urlCustomVariable -Method 'POST' | Out-Null
return