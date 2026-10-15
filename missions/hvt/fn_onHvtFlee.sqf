// The HVT runs: he and up to two bodyguards break off, take the car and drive to the escape road.
private _hvt = _this getVariable ["spo_hvt", objNull];
private _grp = _this getVariable ["spo_hvt_group", grpNull];
private _car = _this getVariable ["spo_hvt_car", objNull];
private _escapePos = _this getVariable ["spo_hvt_escapePos", spo_centerPos];

private _guards = (units _grp select {alive _x && {_x != _hvt}}) select [0, 2];
private _runners = [_hvt] + _guards;
private _fleeGrp = createGroup [east, true];
_runners joinSilent _fleeGrp;
_fleeGrp selectLeader _hvt;
_fleeGrp setBehaviour "CARELESS";
_fleeGrp setSpeedMode "FULL";
_fleeGrp setCombatMode "GREEN";
{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach _runners;
_fleeGrp enableDynamicSimulation false;

[_fleeGrp] call CBA_fnc_clearWaypoints;
if (alive _car && {canMove _car}) then {
	_fleeGrp addVehicle _car;
	// a bodyguard drives if there is one, so the HVT can be shot out of the passenger seat
	private _driver = [_hvt, _guards # 0] select (_guards isNotEqualTo []);
	_driver assignAsDriver _car;
	{ if (_x != _driver) then { _x assignAsCargo _car; }; } forEach _runners;
	_runners orderGetIn true;
	private _wp = _fleeGrp addWaypoint [getPos _car, 0];
	_wp setWaypointType "GETIN";
	_wp waypointAttachVehicle _car;
};
private _wp = _fleeGrp addWaypoint [_escapePos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 20;

"The HVT is running for the exit roads!" remoteExec ["hint", 0];
["HVT is fleeing"] call spo_fnc_log;
