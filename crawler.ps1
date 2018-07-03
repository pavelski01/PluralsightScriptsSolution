﻿param([string]$CourseUrl)
$CourseUrl = $CourseUrl.Substring(0, $CourseUrl.LastIndexOf('/'))
$CourseUrl = $CourseUrl.Substring($CourseUrl.LastIndexOf('/') + 1)
$request = "https://app.pluralsight.com/learner/content/courses/$($CourseUrl)"
$json = Invoke-WebRequest -Uri $request | ConvertFrom-Json
$modulesJ = $json | select modules
$titleJ = $json | select title
$title = $titleJ.title.Replace(':', ' -').Replace('?', '').Trim()
$dict = New-Object 'system.collections.generic.dictionary[string,string[]]'
foreach($clip in $modulesJ.modules.clips)
{
    if ($dict[$clip.moduleTitle.Replace(':', ' -').Replace('?', '').Trim()] -eq $null)
    {
        $dict.Add($clip.moduleTitle.Replace(':', ' -').Replace('?', '').Trim(), @())
    }
    $dict[$clip.moduleTitle.Replace(':', ' -').Replace('?', '').Trim()] += $clip.title.Replace(':', ' -').Replace('?', '').Trim()
}
$index = 0
$courses = New-Object 'system.collections.generic.dictionary[string,string[]]'
$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$scriptDirPath = "$scriptDir\$title\"
foreach($key in $dict.Keys)
{
    $index++
    $indexS = ""
    if ($dict[$key] -eq "Course Overview")
    {
        $index = 0
    }
    if ($index -lt 10)
    {
        $indexS = "0"
    }
    $indexS += $index
    if ($courses["$($indexS) $($key)"] -eq $null)
    {
        $courses.Add("$($indexS) $($key)", $dict[$key])
        New-Item -ItemType Directory -Force -Path "$($scriptDirPath)$($indexS) $($key)" | Out-Null
    }
}
$fileArray = Get-ChildItem -Filter "*.mp4" -File -Path "$scriptDir\$title\"
$fileArray = $fileArray | Sort-Object
foreach ($kvp in $courses.GetEnumerator())
{
    foreach ($val in $kvp.Value)
    {
        $fileArray = Get-ChildItem -Filter "*.mp4" -File -Path "$scriptDir\$title\"
        $fileArray = $fileArray | Sort-Object
        foreach ($file in $fileArray)
        {
            if ($file.Name.ToLower().Replace(' ', '').Replace('_', '').Replace('-', '').Replace('.', '') -like "*$($val.ToLower().Replace(' ', '').Replace('_', '').Replace('-', '').Replace('.', ''))*")
            {
                Move-Item -Path $file.FullName -Destination "$($scriptDirPath)$($kvp.Key)\$($file.Name)"
                $srt = $file.FullName.Substring(0, $file.FullName.IndexOf('.')) + '.en.srt'
                $isSrt = Test-Path -Path $srt
                if ($isSrt)
                {
                    Move-Item -Path $srt -Destination "$($scriptDirPath)$($kvp.Key)\$($file.Name.Substring(0, $file.Name.IndexOf('.'))).en.srt"
                }
                break          
            }
        }        
    }
}