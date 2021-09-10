function tail {param([string]$path) Get-Content -Wait  -Tail 50 -Path $path}

function pinglan {param([string]$net) 1..255 | %{write-output "$net.$_"; ping -n 1 -w 200 $net.$_} |Select-String ttl}