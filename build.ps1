$islands = "enoch","Tanoa","Malden","Takistan","tem_anizay","fallujah","fapovo";
New-Item -ItemType "directory" -Name "addons";
foreach ($island in $islands) {
    New-Item -ItemType "directory" -Name "static_platoon_ops.$island" -Path "addons"
    Copy-Item -Destination addons/static_platoon_ops.$island -Exclude .git, addons -Filter * -Recurse
}