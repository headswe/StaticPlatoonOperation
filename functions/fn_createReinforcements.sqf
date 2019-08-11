private _numberOfMen = random 8 max 4;
private _grp = [[0,0,0], _numberOfMen] call dsm_fnc_createSquad;

private _spawnPos = selectRandom dsm_reinforcement_locations;

if(dsm_vehicleFaction != '') then {
	private _vehicles = ((dsm_factions getVariable [dsm_vehicleFaction, []]) # 2) apply {[getNumber ((_x) >> "transportSoldier"), _x]};;
	_vehicles sort true;
	_vehicles = _vehicles select {_x#0 >= 3 && !((configName (_x#1)) isKindOf "ship")};
	private _pickedVehicles = [];
	private _spots = 0;
	while {_spots < _numberOfMen } do {
		private _pickedVehicle = selectRandom _vehicles;
		_spots = _spots + (_pickedVehicles#0);
		_pickedVehicles pushBack (_pickedVehicle#1);
	};
	poop = _pickedVehicles;
	private _spawnedVehicles = [];
	{
		_className = (configName _x);
		private _veh = createVehicle [_className, _spawnPos, [], 0,'FLY'];
		_spawnedVehicles pushBack (_veh);
		_grp addVehicle _veh;
	} foreach _pickedVehicles;

	_index = 0;
	{
		while {isNull objectParent _x} do {
			_try = _x moveInAny (_spawnedVehicles # _index);
			if(!_try) then {
				_index = _index +1;
			};
		}
	} foreach units _grp;
		private _wp = _grp addWaypoint [getpos leader _grp, -1];
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointTimeout  [3,6,9];
		_wp = _grp addWaypoint [getpos leader _grp, -1];
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointPosition (getpos leader _grp);
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 100;
		_wp = _grp addWaypoint [dsm_centerPos, -1];
		_wp setWaypointType "SAD";
		_wp setWaypointCompletionRadius 100;
}
