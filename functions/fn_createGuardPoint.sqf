	params ["_spawnPos"];
	private _overwatchPos = [_spawnPos, 0, 150, 2, 0, 5, 0, [], [_spawnPos,_spawnPos]] call BIS_fnc_findSafePos;
	if(_overwatchPos isEqualTo _spawnPos) then {
		_spawnPos = _spawnPos findEmptyPosition [0, 30, "B_Quadbike_01_F"];
	} else {
		_spawnPos = _overwatchPos;
	};

	private _grp = [_spawnPos, random [2,3,4]] call spo_fnc_createSquad;
	_grp setBehaviour "SAFE";
	_grp setVariable ["spo_grp_type", 'guard'];
    [_grp, _spawnPos, 50, 4, spo_objective_area, false] call lambs_wp_fnc_taskPatrol;
	spo_patrol_groups pushBack _grp;
	spo_overwatch_locations pushBack _spawnPos;
	private _mkrName = format["gp_%1", random 3000];
	[_mkrName, _spawnPos, "ICON", [1,1], "TYPE:", "o_installation" ] call CBA_fnc_createMarker
	