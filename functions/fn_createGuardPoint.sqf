	params ["_spawnPos"];
	private _overwatchPos = [dsm_centerPos, dsm_perimeter_radius, dsm_objective_radius*3,5, _spawnPos] call BIS_fnc_findOverwatch;
	if(_overwatchPos isEqualTo _spawnPos) then {
		_spawnPos = _spawnPos findEmptyPosition [0, 30, "B_Quadbike_01_F"];
	} else {
		_spawnPos = _overwatchPos;
	};
	"Campfire_burning_F" createVehicle _spawnPos;
	private _grp = [_spawnPos, 2] call dsm_fnc_createSquad;
	_grp setBehaviour "SAFE";
	_grp allowFleeing 0;
	_grp setVariable ["dsm_grp_type", 'guard'];
	dsm_guard_groups pushBack _grp;