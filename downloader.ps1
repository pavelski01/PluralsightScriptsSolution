param([string]$CourseUrl,[string]$SuffixPath,[int]$PlaylistStart=1,[bool]$OnlySubs=0)
$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if ($SuffixPath -ne $null) { $scriptDir = Join-Path -Path $scriptDir -ChildPath "$SuffixPath\" }
$additionalOptions = [string]::Empty
if ($OnlySubs -eq 1) { $additionalOptions = -join($additionalOptions, "--skip-download") }
.\youtube-dl.exe --output "$scriptDir%(playlist_title)s\%(autonumber)003d %(title)s-%(id)s.%(ext)s" --all-subs --username "" --password "" --verbose --sleep-interval 120 $additionalOptions "$CourseUrl" --playlist-start "$PlaylistStart" -f best --no-cache-dir --print-traffic #--dump-pages