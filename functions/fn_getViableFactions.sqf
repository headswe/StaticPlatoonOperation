private _allVehs = ("true" configClasses (configFile >> "CfgVehicles"));
dsm_factions = [true] call CBA_fnc_createNamespace;
{
	private _configName = configName _x;
	private _isVehicle = _x isKindOf 'AllVehicles';
	private _isNotMan = !(configName isKindOf 'Man');
	if(_isVehicle && _isNotMan) then {
		private _factionStr = (getText (_x >> 'faction'));
		if(_factionStr != '') then {
			private _faction = dsm_factions getVariable [_factionStr, []];
			if(count _faction <= 0) then {
				_faction = [(configfile >> "CfgFactionClasses" >> _factionStr),getText (configfile >> "CfgFactionClasses" >> _factionStr >> "displayName"), [_x]];
			} else {
				(_faction#2) pushBackUnique _x;
			};
			dsm_factions setVariable [_factionStr, _faction];
		};
	};
} forEach _allVehs;
publicVariable "dsm_factions";