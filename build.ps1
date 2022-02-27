$islands = "enoch","Tanoa","Malden","Takistan","tem_anizay","fallujah","fapovo", "lythium", "Altis", "tem_kujari", "cup_chernarus_A3", "gm_weferlingen_summer", "gm_weferlingen_winter", "tem_chamw","tem_cham","oski_ire";
$exclude = ".git","addons", "addons\*";
$source = "C:\Users\heads\OneDrive\Documents\Arma 3 - Other Profiles\Head\mpmissions\static_platoon_ops.enoch"
foreach ($island in $islands) {
    $folders = Get-ChildItem $source -Recurse | where  {$_.FullName -notcontains ".git" -and $_.FullName -notcontains "addons"};
    $folders | Copy-Item -Destination {Join-Path "C:\Users\heads\OneDrive\Documents\Arma 3 - Other Profiles\Head\mpmissions\addons\static_platoon_ops.$island" $_.FullName.Substring($source.length)}
}