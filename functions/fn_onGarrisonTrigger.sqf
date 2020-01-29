params ["_trigger"];
private _grp = _trigger getVariable ['grp', grpNull];
private _units = units _grp;
_units = _units select [0, (floor (count _units)/2) max 1];
{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach _units;

private _wp = _grp addWaypoint [getPos (leader _grp), -1];
_wp setWaypointType "SAD";
_wp setWaypointCompletionRadius 300;