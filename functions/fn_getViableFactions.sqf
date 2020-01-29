private _allVehs = ("true" configClasses (configFile >> "CfgVehicles")) select {{(configName _x) isKindOf 'AllVehicles' && !((configName _x) isKindOf 'Man')}};

dsm_factions = [true] call CBA_fnc_createNamespace;
publicVariable "dsm_factions";
{
	private _factionStr = (getText (_x >> 'faction'));
	if(_factionStr != '') then {
		private _faction = dsm_factions getVariable [_factionStr, []];
		if(count _faction <= 0) then {
			_faction = [(configfile >> "CfgFactionClasses" >> _factionStr),getText (configfile >> "CfgFactionClasses" >> _factionStr >> "displayName"), [_x]];
		} else {
			(_faction#2) pushBackUnique _x;
		};
		dsm_factions setVariable [_factionStr, _faction,true];
	}
} forEach _allVehs;