// Server: groups every public vehicle by faction for the setup dialog and the vehicle getters.
// Reading CfgVehicles takes a while with big mod sets, so progress is published in spo_factionScanProgress (0..1)
// and the dialog shows it until spo_factions arrives.
spo_factionScanProgress = 0;
publicVariable "spo_factionScanProgress";
// filtered by the engine: only spawnable (scope 2) entries that belong to a faction
private _allVehs = "getNumber (_x >> 'scope') == 2 && {getText (_x >> 'faction') != ''}" configClasses (configFile >> "CfgVehicles");
// faction class -> [CfgFactionClasses entry, display name, [vehicle configs]]
private _factionsVehicles = createHashMap;
private _factions = [];
private _total = (count _allVehs) max 1;
private _nextReport = 0.05;
{
	private _configName = configName _x;
	if ((_configName isKindOf 'AllVehicles') && {!(_configName isKindOf 'Man')}) then {
		private _factionStr = getText (_x >> 'faction');
		private _faction = _factionsVehicles getOrDefault [_factionStr, []];
		if (_faction isEqualTo []) then {
			_faction = [(configFile >> "CfgFactionClasses" >> _factionStr), getText (configFile >> "CfgFactionClasses" >> _factionStr >> "displayName"), [_x]];
			_factions pushBack [_factionStr, _faction # 1];
			_factionsVehicles set [_factionStr, _faction];
		} else {
			(_faction # 2) pushBackUnique _x;
		};
	};
	if (_forEachIndex / _total >= _nextReport) then {
		spo_factionScanProgress = _forEachIndex / _total;
		publicVariable "spo_factionScanProgress";
		_nextReport = _nextReport + 0.05;
	};
} forEach _allVehs;
spo_factionsVehicles = _factionsVehicles;
spo_factions = _factions;
publicVariable "spo_factions";
spo_factionScanProgress = 1;
publicVariable "spo_factionScanProgress";
