$islands = "enoch","Tanoa","Malden","Takistan","tem_anizay","fallujah","fapovo", "lythium";
$exclude = ".git","addons", "addons\*";
$source = "D:\Documents\Arma 3 - Other Profiles\Head\mpmissions\static_platoon_ops.enoch"
foreach ($island in $islands) {
    $folders = Get-ChildItem $source -Recurse | where  {$_.FullName -notcontains ".git" -and $_.FullName -notcontains "addons"};
    $folders | Copy-Item -Destination {Join-Path "D:\Documents\Arma 3 - Other Profiles\Head\mpmissions\addons\static_platoon_ops.$island" $_.FullName.Substring($source.length)}
}