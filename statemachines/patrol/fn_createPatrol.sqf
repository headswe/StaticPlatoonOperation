	this params ["_numberOfMen", "_spawnPos"];
	private _grp = [_spawnPos, _numberOfMen] call spo_fnc_createSquad;
	_grp setCombatMode "RED";

	{_x setPos _spawnPos} forEach units _grp;
	if (random 1 > 0.3) then {
		[_grp, spo_centerPos, spo_objective_radius, 4, spo_objective_area, true] call lambs_wp_fnc_taskPatrol;
	} else {
		[_grp, spo_centerPos, spo_perimeter_radius, 4, spo_perimeter_area, true] call lambs_wp_fnc_taskPatrol;
	};
	spo_patrol_groups pushBack _grp;
	spo_ai_initialManpower = spo_ai_initialManpower - _numberOfMen;