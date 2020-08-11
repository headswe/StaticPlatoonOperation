	this params ["_numberOfMen", "_spawnPos"];
	private _grp = [_spawnPos, _numberOfMen] call spo_fnc_createSquad;
	_grp setCombatMode "RED";

	{_x setPos _spawnPos} forEach units _grp;

    [_grp, _spawnPos, 200, 4, spo_objective_area, true] call lambs_wp_fnc_taskPatrol;
	spo_patrol_groups pushBack _grp;
	spo_ai_initialManpower = spo_ai_initialManpower - _numberOfMen;