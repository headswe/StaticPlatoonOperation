params ["_trigger"];
private _grp = _trigger getVariable ['grp', grpNull];

{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach units _grp;

private _wp = _grp addWaypoint [getPos (leader _grp), -1];
_wp setWaypointType "SAD";
_wp setWaypointCompletionRadius 300;