private _allVehs = ("true" configClasses (configFile >> "CfgVehicles"));
// faction class -> [CfgFactionClasses entry, display name, [vehicle configs]]; server only
spo_factionsVehicles = createHashMap;
spo_factions = [];
{
	private _configName = configName _x;
	private _isVehicle = _configName isKindOf 'AllVehicles';
	private _isNotMan = !(_configName isKindOf 'Man');
	if(_isVehicle && _isNotMan) then {
		private _factionStr = (getText (_x >> 'faction'));
		if(_factionStr != '') then {
			private _faction = spo_factionsVehicles getOrDefault [_factionStr, []];
			if(count _faction <= 0) then {
				_faction = [(configFile >> "CfgFactionClasses" >> _factionStr),getText (configFile >> "CfgFactionClasses" >> _factionStr >> "displayName"), [_x]];
				spo_factions pushBack [_factionStr, _faction # 1];
			} else {
				(_faction#2) pushBackUnique _x;
			};
			spo_factionsVehicles set [_factionStr, _faction];
		};
	};
} forEach _allVehs;
publicVariable "spo_factions";
