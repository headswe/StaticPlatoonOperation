$PATH_TO_CUSTOM_CONFIG = '.\build-config.json';
$DEFAULT_CONFIG = [PSCustomObject]@{
    source=$pwd.Path;
    destination="$source\addons";
    islands="Stratis", "Altis", "Enoch", "Tanoa", "Malden";
    exclude="\.git$", "\\\.git\\", "\\addons$", "\\addons\\", "\\build.ps1$", "\\build-config.json$", "\\build-config.json.example$";
}

$config = $DEFAULT_CONFIG;

# Override default config with build-config.json overrides
if (Test-Path $PATH_TO_CUSTOM_CONFIG) {
    $custom_config = (Get-Content -Raw $PATH_TO_CUSTOM_CONFIG | ConvertFrom-Json)
   
    $config.PSObject.Properties | ForEach-Object {
        $_key = $_.Name;
        $_custom_value = $custom_config.$_key
        if (!($null -eq $_custom_value)) { $config.$_key = $_custom_value }
    }
}

# Override config with cli arguments
if (!($null -eq $args[0])) {
    $config.destination = $args[0];
}

Write-Output $config;

$source = $config.source;
$destination = $config.destination;
$islands = $config.islands;

# Get files to copy
$folders = Get-ChildItem $source -Recurse
foreach ($exclude in $config.exclude) {
    $folders = $folders | Where-Object {$_.FullName -notmatch $exclude}
}

# Create mission for each island
foreach ($island in $islands) {
    $folders | Copy-Item -Destination {Join-Path "$destination\static_platoon_ops.$island" $_.FullName.Substring($source.length)}
}