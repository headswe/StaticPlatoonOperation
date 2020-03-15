private _allVehs = ("true" configClasses (configFile >> "CfgVehicles"));
dsm_factionsVehicles = [true] call CBA_fnc_createNamespace;
dsm_factions = [];
{
	private _configName = configName _x;
	private _isVehicle = _configName isKindOf 'AllVehicles';
	private _isNotMan = !(_configName isKindOf 'Man');
	if(_isVehicle && _isNotMan) then {
		private _factionStr = (getText (_x >> 'faction'));
		if(_factionStr != '') then {
			private _faction = dsm_factionsVehicles getVariable [_factionStr, []];
			if(count _faction <= 0) then {
				_faction = [(configfile >> "CfgFactionClasses" >> _factionStr),getText (configfile >> "CfgFactionClasses" >> _factionStr >> "displayName"), [_x]];
				dsm_factions pushBack [_factionStr, _faction # 1];
			} else {
				(_faction#2) pushBackUnique _x;
			};
			dsm_factionsVehicles setVariable [_factionStr, _faction];
		};
	};
} forEach _allVehs;
publicVariable "dsm_factions";