param([string]$CourseUrl,[string]$SuffixPath,[int]$PlaylistStart=1,[bool]$SubsOnly=0)
$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if ($SuffixPath -ne $null) 
{ 
	$scriptDir = Join-Path -Path $scriptDir -ChildPath "$SuffixPath\" 
}
$additionalOptions = [string]::Empty
if ($SubsOnly -eq 1) 
{ 
	$additionalOptions = -join($additionalOptions, "--skip-download") 
}
.\youtube-dl.exe --output "$scriptDir%(playlist_title)s\%(autonumber)003d %(title)s-%(id)s.%(ext)s" --all-subs --username "[user]" --password "[passwd]" --verbose --sleep-interval 120 $additionalOptions "$CourseUrl" --playlist-start "$PlaylistStart" -f best --no-cache-dir --print-traffic #--user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20100101 Firefox/10.0 (Chrome)" -4 --dump-pages
.\crawler.ps1 -CourseUrl $CourseUrl