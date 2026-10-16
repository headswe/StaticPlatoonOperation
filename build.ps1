# Copies this mission folder to one mission folder per terrain.
#   .\build.ps1                                   # source = this folder, output = <mpmissions>\addons
#   .\build.ps1 -Destination D:\out -Islands enoch,Altis
param(
    [string]$Source = $PSScriptRoot,
    [string]$Destination = (Join-Path (Split-Path $PSScriptRoot -Parent) "addons"),
    [string]$Name = "static_platoon_ops",
    [string[]]$Islands = @("enoch","Tanoa","Malden","Takistan","tem_anizay","fallujah","fapovo", "lythium", "Altis", "tem_kujari", "cup_chernarus_A3", "gm_weferlingen_summer", "gm_weferlingen_winter", "tem_chamw","tem_cham","oski_ire")
)

# Development files that should not ship with the mission.
$exclude = @(".git", ".github", ".hemtt", "tools", "addons", "CLAUDE.md", "build.ps1", ".gitignore")

$Source = (Resolve-Path $Source).Path.TrimEnd('\')
$files = Get-ChildItem $Source -Recurse -File | Where-Object {
    $relative = $_.FullName.Substring($Source.Length + 1)
    $top = ($relative -split '[\\/]')[0]
    $exclude -notcontains $top
}

foreach ($island in $Islands) {
    $target = Join-Path $Destination "$Name.$island"
    foreach ($file in $files) {
        $dest = Join-Path $target $file.FullName.Substring($Source.Length + 1)
        New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
        Copy-Item $file.FullName -Destination $dest -Force
    }
    Write-Host "Built $target"
}
