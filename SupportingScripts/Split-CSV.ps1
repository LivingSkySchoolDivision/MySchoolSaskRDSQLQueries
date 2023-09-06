param(
    [Parameter(Mandatory=$true)][string]$Infile,
    [Parameter(Mandatory=$true)][string]$ColumnToSplit
)

## ############################################################################################
## # USAGE EXAMPLES                                                                           #
## #                                                                                          #
## # You have a file with a "school" column and want to make separate files for each school.  #
## # > ./Split-CSV InputFile.csv School                                                       #
## #                                                                                          #
## ############################################################################################

$CSV = import-csv $Infile
$SeenSplitValues = [ordered]@{}

# Check to make sure the file exists
if (Test-Path $Infile) {
    write-host "Checking if input file exists: YES"
} else {
    write-host "Checking if input file exists: NO"
    write-host "Could not find the specified file."
    exit
}

# Check to make sure the given column exists
if ($CSV[1].$ColumnToSplit) {
    write-host "Checking if column exists: YES"
} else {
    write-host "Checking if column exists: NO"
    write-host "Specified column does not exist in the CSV file"
    exit
}

# If we got this far, we're probably OK to continue

write-host "Sorting rows by specified column..."
foreach ($Row in $CSV)
{
    if (-not ($SeenSplitValues.Contains($Row.$ColumnToSplit))) {
        $SeenSplitValues.Add($Row.$ColumnToSplit, @())
    }

    $SeenSplitValues[$Row.$ColumnToSplit] += $Row
}

write-host "Exporting CSV files..."
foreach($key in $SeenSplitValues.Keys) {
    write-host $key
    $OutFileName = ((Get-Item $Infile).BaseName + "_" + $key + ".csv") -replace '[^0-9a-zA-Z\.\-_]', ''
    write-host $OutFileName

    $SeenSplitValues[$key] | Export-Csv -Path $OutFileName -UseCulture -NoTypeInformation
}