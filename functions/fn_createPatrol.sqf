	this params ["_numberOfMen", "_spawnPos" , "_patrolDir"];
	private _grp = [_spawnPos, _numberOfMen] call dsm_fnc_createSquad;
	_grp setCombatMode "RED";
	_grp allowFleeing 0;
	_patrolDir = _patrolDir + 180;


	_wp = _grp addWaypoint [_spawnPos, -1];

	_wp = _grp addWaypoint [_spawnPos, -1];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "STAG COLUMN";
	_wp setWaypointTimeout [3,6,9];
	_wp setWaypointCompletionRadius 100;

	_otherpos = dsm_centerPos getpos [(dsm_objective_radius+(random dsm_perimeter_radius)) min dsm_perimeter_radius, _patrolDir];
	_wp = _grp addWaypoint [_otherpos, -1];
	_wp setWaypointTimeout [3,6,9];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 100;

	_wp = _grp addWaypoint [_spawnPos, -1];
	_wp setWaypointType "CYCLE";


	{_x setPos _spawnPos} forEach units _grp;
	// Create waypoint patrol
	dsm_patrol_groups pushBack _grp;
	dsm_aiRatioCount = dsm_aiRatioCount - _numberOfMen;