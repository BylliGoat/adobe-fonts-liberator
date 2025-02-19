#################################################################################
#
#   https://github.com/pawalan/adobe-fonts-liberator
#   kudos to Steven Kalinke <https://github.com/kalaschnik/adobe-fonts-revealer>
#
################################################################################



# Configuration - usually no need to change something, but suit yourself
$AdobeFontsDir = "$env:APPDATA\Adobe\CoreSync\plugins\livetype\r"
$DesktopDir = [Environment]::GetFolderPath("Desktop")
$DestinationDir = Join-Path -Path $DesktopDir -ChildPath 'Adobe Fonts'



######################### script code - don't change unless you know what you do! ###############################################
Clear-Host

Add-Type -AssemblyName System.Drawing

Write-Output "`n`rLiberating Adobe Fonts`n`r`n`rfrom`t$AdobeFontsDir`n`rto`t`t$DestinationDir`n`r`n`r"


if ( Test-Path -Path "$DestinationDir\*" ) {
    Write-Error "Destination directory is not empty, aborting."
    exit 1
} else {
    New-Item -Path $DestinationDir -ItemType Directory -Force | Out-Null
}


Get-ChildItem -Path $AdobeFontsDir -Force | ForEach-Object {
    try {
        $fontCollection = New-Object System.Drawing.Text.PrivateFontCollection
        $fontCollection.AddFontFile($_.FullName)

        $fontName = $fontCollection.Families[-1].Name
        $originalName = $_.Name
        $uniqueFontName = "$fontName - $originalName"

        # Ensure the unique name ends with .otf
        if (-not $uniqueFontName.EndsWith(".otf")) {
            $uniqueFontName += ".otf"
        }

        $fontFile = Join-Path -Path $DestinationDir -ChildPath $uniqueFontName

        Copy-Item -Path $_.FullName -Destination $fontFile
        Write-Output "Liberated`t$_`tto`t$uniqueFontName"
    } catch {
        Write-Error "Failed to process`t$_`tError: $($_.Exception.Message)"
    }
}

Write-Output "`n`r`n`rLong live the free fonts!`n`r`n`rBye!`n`r"

# Keep the window open until a key is pressed
Read-Host -Prompt "Press any key to exit..."
