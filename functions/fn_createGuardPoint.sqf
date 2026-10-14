	params ["_spawnPos"];
	private _overwatchPos = [_spawnPos, 0, 150, 2, 0, 5, 0, [], [_spawnPos,_spawnPos]] call BIS_fnc_findSafePos;
	if(_overwatchPos isEqualTo _spawnPos) then {
		private _empty = _spawnPos findEmptyPosition [0, 30, "B_Quadbike_01_F"];
		if (_empty isNotEqualTo []) then { _spawnPos = _empty; };
	} else {
		_spawnPos = _overwatchPos;
	};

	private _grp = [_spawnPos, random [3,6,8]] call spo_fnc_createSquad;
	_grp setBehaviour "SAFE";
	_grp setVariable ["spo_grp_type", 'guard'];
    [_grp, _spawnPos, 50] call lambs_wp_fnc_taskCamp;
	spo_patrol_groups pushBack _grp;
	spo_overwatch_locations pushBack _spawnPos;
	spo_guardPointCount = (missionNamespace getVariable ["spo_guardPointCount", 0]) + 1;
	private _mkrName = format["gp_%1", spo_guardPointCount];
	[_mkrName, _spawnPos, "ICON", [1,1], "TYPE:", "o_installation" ] call CBA_fnc_createMarker
	
