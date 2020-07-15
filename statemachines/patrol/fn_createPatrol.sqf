	this params ["_numberOfMen", "_spawnPos"];
	private _grp = [_spawnPos, _numberOfMen] call spo_fnc_createSquad;
	_grp setCombatMode "RED";

	
	private _owerwatches = [] + spo_overwatch_locations;
	_owerwatches apply {[_x distance2D _spawnPos, _x]};
	_owerwatches sort true;
	// add intial waypoint at spawn
	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp setWaypointType "MOVE";
		_wp setWaypointTimeout [5,6,9];
	// setup the formations
	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "STAG COLUMN";
	_wp setWaypointTimeout [3,6,9];
	_wp setWaypointCompletionRadius 100;

    private _pos = ((selectBestPlaces [(getMarkerPos spo_perimeter_mkrName), spo_perimeter_radius, "(0 - (waterDepth))", 50, 1]) # 0) # 0; 
    _wp = _grp addWaypoint [_pos , 0];
    _wp setWaypointTimeout [3,6,9];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 100;

	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp setWaypointType "CYCLE";


	{_x setPos _spawnPos} forEach units _grp;
	// Create waypoint patrol
	spo_patrol_groups pushBack _grp;
	spo_ai_initialManpower = spo_ai_initialManpower - _numberOfMen;