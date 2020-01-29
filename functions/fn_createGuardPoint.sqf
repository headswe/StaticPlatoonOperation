	params ["_spawnPos"];
	private _overwatchPos = [_spawnPos, 0, 150, 2, 0, 5, 0, [], [_spawnPos,_spawnPos]] call BIS_fnc_findSafePos;
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
	[_grp, _spawnPos, 0, 4, random 50, true] call dsm_fnc_patrol;
	dsm_guard_groups pushBack _grp;