param(
    [Parameter()]
    $skin
)

function debug {
    param(
        [Parameter()]
        [string]
        $message
    )

    $RmAPI.Bang("[!Log `"`"`"" + $message + "`"`"`" Debug]")
}

function warning {
    param(
        [Parameter()]
        [string]
        $message
    )

    $RmAPI.Bang("[!Log `"`"`"CoreInstaller: " + $message + "`"`"`" Warning]")
}

function rmerror {
    param(
        [Parameter()]
        [string]
        $message
    )

    $RmAPI.Bang("[!Log `"`"`"CoreInstaller: " + $message + "`"`"`" Error]")
}

function notice {
    param(
        [Parameter()]
        [string]
        $message
    )

    $RmAPI.Bang("[!Log `"`"`"CoreInstaller: " + $message + "`"`"`"]")
}

function Get-IniContent ($filePath) {
    $ini = [ordered]@{}

    $notSectionCount = 0

    foreach ($line in [System.IO.File]::ReadLines($filePath)) {
        if ($line -match "^\s*\[(.+?)\]\s*$") {
            $section = $matches[1]
            if ($ini.Keys -notcontains $section) {
                $ini.Add($section, [ordered]@{})
            }
            $notSectionCount = 0
        }
        elseif ($line -match "^\s*;.*$") {
            $ini[$section].Add(";NotSection" + $notSectionCount, $line)
            $notSectionCount++
        }
        elseif ($line -match "^\s*(.+?)\s*=\s*(.+?)$") {
            $key, $value = $matches[1..2]
            $ini[$section].Add($key, $value)
        }
        else {
            $ini[$section].Add(";NotSection" + $notSectionCount, $line)
            $notSectionCount++
        }
    }

    return $ini
}

function Set-IniContent($ini, $filePath) {
    $str = @()

    foreach ($section in $ini.GetEnumerator()) {
        $str += "[" + $section.Key + "]"
        foreach ($keyvaluepair in $section.Value.GetEnumerator()) {
            if ($keyvaluepair.Key -match "^;NotSection\d+$") {
                $str += $keyvaluepair.Value
            }
            else {
                $str += $keyvaluepair.Key + " = " + $keyvaluepair.Value
            }
        }
    }

    $finalStr = $str -join [System.Environment]::NewLine

    $finalStr | Out-File -filePath $filePath -Force -Encoding unicode
}

$skinsPath = $RmAPI.VariableStr('SKINSPATH')
$root = $RmAPI.VariableStr("@") + "CoreInstaller"
$requiresVariableSync = $false

$RmAPI.Bang("[!SetVariable Progress `"25`"][!SetVariable InstallText `"Looking for old files...`"][!UpdateMeterGroup Progress][!Redraw]")

if ([System.IO.Directory]::Exists("$skinsPath$skin")) {
    debug("Requires variable sync...")
    $RmAPI.Bang("[!SetVariable Progress `"20`"][!SetVariable InstallText `"Removing old files...`"][!UpdateMeterGroup Progress][!Redraw]")
    Copy-Item -LiteralPath "$skinsPath$skin" -Destination "$root\cache\Old$skin" -Force -Recurse

    # Remove-Item "$skinsPath$skin" -Force
    $requiresVariableSync = $true
}

if (-not (Test-Path "$root\cache\$skin\VariableFiles.txt")) {
    debug("No VariableFiles.txt found!")
    $requiresVariableSync = $false
}

$itemsToCopyFromOld = @()

if (($requiresVariableSync) -or ($skin -eq 'JaxCore')) {
    $RmAPI.Bang("[!SetVariable Progress `"28`"][!SetVariable InstallText `"Syncing variables...`"][!UpdateMeterGroup Progress][!Redraw]")

    [System.IO.File]::ReadAllLines("$root\cache\$skin\VariableFiles.txt") | ForEach-Object {

        debug('Syncing - ' + $_)

        if (-not [System.IO.File]::Exists("$root\cache\Old$skin\$_")) {
            if (-not [System.IO.File]::Exists("$root\cache\$skin\Skins\$_")) {
                rmerror("CoreInstaller: Variable file $_ not found! (Error: )")
                continue
            }
            debug("Not found in old - $_")
        }
        elseif (-not [System.IO.File]::Exists("$root\cache\$skin\Skins\$_")) {
            debug("Not found in new - $_")
            $itemsToCopyFromOld += $_
        }
        else {
            debug("Working on variable file - $_")

            $oldIni = Get-IniContent -filePath "$root\cache\Old$skin\$_"
            $newIni = Get-IniContent -filePath "$root\cache\$skin\Skins\$_"

            $newIniEnum = Get-IniContent -filePath "$root\cache\$skin\Skins\$_"

            foreach ($section in $newIniEnum.GetEnumerator()) {

                if ($oldIni.Keys -notcontains $section.Key) {
                    debug("$($section.Key) not found in `$oldIni")
                    continue
                }

                foreach ($keyvaluepair in $section.Value.GetEnumerator()) {

                    if ($oldIni[$section.Key].Keys -contains $keyvaluepair.Key) {
                        $newIni[$section.Key][$keyvaluepair.Key] = $oldIni[$section.Key][$keyvaluepair.Key]
                    }
                    elseif ($keyvaluepair.Value -match "^\s*\{([^:]+):([^\(\)]+)\((.*)\)\}\s*$") {
                        $sec, $k, $v = $matches[1..3].ToUpper()
                        if ($oldIni.Keys -contains $sec) {
                            if ($oldIni[$sec].Keys -contains $k) {
                                $newIni[$section.Key][$keyvaluepair.Key] = $oldIni[$sec][$k]
                            }
                            else {
                                $newIni[$section.Key][$keyvaluepair.Key] = $v
                            }
                        }
                        else {
                            $newIni[$section.Key][$keyvaluepair.Key] = $v
                        }
                    }
                }
            }

            foreach ($section in $oldIni.GetEnumerator()) {
                if ($newIni.Keys -notcontains $section.Key) {
                    $newIni[$section.Key] = [ordered]@{}
                }

                foreach ($keyvaluepair in $section.Value.GetEnumerator()) {
                    if ($newIni[$section.Key].Keys -notcontains $keyvaluepair.Key) {
                        $newIni[$section.Key][$keyvaluepair.Key] = $keyvaluepair.Value
                    }
                }
            }

            Set-IniContent -ini $newIni -filePath "$root\cache\$skin\Skins\$_"
        }
    }
}
else {
    debug("Skipped variable sync")
    [System.IO.File]::ReadAllLines("$root\cache\$skin\VariableFiles.txt") | ForEach-Object {
        Write-Host $_
        $newIni = Get-IniContent -filePath "$root\cache\$skin\Skins\$_"
        $newIniEnum = $newIni.GetEnumerator()

        foreach ($section in $newIniEnum) {
            foreach ($keyvaluepair in $section.Value.GetEnumerator()) {
                if ($keyvaluepair.Value -match "^\s*\{([^:]+):([^\(\)]+)\((.*)\)\}\s*$") {
                    $sec, $k, $v = $matches[1..3].ToUpper()
                    $newIni[$section.Key][$keyvaluepair.Key] = $v
                }
            }
        }

        Set-IniContent -ini $newIni -filePath "$root\cache\$skin\Skins\$_"
    }
}

$RmAPI.Bang("[!SetVariable Progress `"60`"][!SetVariable InstallText `"Finalizing variable sync...`"][!UpdateMeterGroup Progress][!Redraw]")

foreach ($item in $itemsToCopyFromOld) {
    $old = "$root\cache\Old$skin\$item"
    $new = "$root\cache\$skin\Skins\$item"
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($new))
    Copy-Item -LiteralPath $old -Destination $new -Force
}