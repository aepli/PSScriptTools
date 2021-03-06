Function Write-Detail {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [string]$Message,
        [ValidateSet("BEGIN","PROCESS","END")]
        [string]$Prefix = "PROCESS",
        [switch]$NoDate
    )

    $pfx = $($Prefix.ToUpper()).PadRight("process".length)
    if ($Nodate) {
        $dt = (Get-Date -Format "hh:mm:ss:ffff")
    }
    else {
        $dt = "{0} {1}" -f (Get-Date).ToShortDateString(),(Get-Date -Format "hh:mm:ss:ffff")
    }
    $Text = "$dt [$pfx] $Message"
    Write-Output $Text

} #close Write-Detail

Function Out-VerboseTee {
    [CmdletBinding()]
    Param(
     [Parameter(Mandatory,ValueFromPipeline)]   
     [object]$Value,
     [Parameter(Position=0,Mandatory)]
     [string]$Path,
     [System.Text.Encoding]$Encoding,
     [switch]$Append
    )
    Begin { 
        #turn on verbose pipeline since if you are running this command you intend for it to be on
        $VerbosePreference = "continue"
    }
    Process {
        #only run if Verbose is turned on
        if ($VerbosePreference -eq "continue") {
            $Value | Out-String | Write-Verbose
            $PSBoundParameters.Remove("Append") | Out-Null
            if ($Append) {
                Add-Content @PSBoundParameters
            }
            else {
                Set-Content @PSBoundParameters
            }
        }
    }
    End {
        $VerbosePreference = "silentlycontinue"
    }
} #close Out-VerboseTee

