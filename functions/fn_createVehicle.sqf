params [["_spawnPos",dsm_centerPos], ["_type", "transport", ["transport", "combat"]] , ["_flying", false], ["_static", false], ["_boat", false] ];

private _pos = [_spawnPos, 0, dsm_objective_radius, 2, 0, 20, 0, [], [_spawnPos,_spawnPos]] call BIS_fnc_findSafePos;
private _vehicles = ((dsm_factions getVariable [dsm_vehicleFaction, []]) # 2) select {!((_x >> "isUav") call BIS_fnc_getCfgDataBool)};
if(!_boat) then {
	_vehicles = _vehicles select {!((configName _x) isKindOf "Ship")};
};
if(!_flying) then {
	_vehicles = _vehicles select {!((configName _x) isKindOf "Helicopter") && !((configName _x) isKindOf "Plane")};
};
if(!_static) then {
	_vehicles = _vehicles select {!((configName _x) isKindOf "StaticWeapon")};
};

switch (_type) do {
	case "transport": {
			_vehicles = _vehicles select {[_x , 'transportSoldier'] call BIS_fnc_getCfg > 3};
		};
		case "combat": {
			_vehicles = _vehicles select {(((_x >> "threat") call BIS_fnc_getCfgDataArray)#0) > 0.3};
		};
	default { };
};

private _veh = objNull;
if(count _vehicles > 0) then {
	_vehicleConfig = (selectRandom _vehicles);

	private _grp = createGroup east;
	_veh = createVehicle [configName _vehicleConfig, _pos, [], 0,'FLY'];
	private _crewCount = {round getNumber (_x >> "dontCreateAI") < 1 && 
					((_x == _vehicleConfig && {round getNumber (_x >> "hasDriver") > 0}) ||
					(_x != _vehicleConfig && {round getNumber (_x >> "hasGunner") > 0}))} count ([configName _vehicleConfig, configNull] call BIS_fnc_getTurrets);
	private _grp = [[0,0,0], _crewCount] call dsm_fnc_createSquad;
	{_x moveInAny _veh} forEach units _grp;
};
_veh