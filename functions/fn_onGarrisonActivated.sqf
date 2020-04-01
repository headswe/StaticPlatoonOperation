{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach units _this;
_this call dsm_fnc_requestReinforcement;
[_this] call CBA_fnc_clearWaypoints;
private _wp = [_this, _this, 0, "SAD", "AWARE", "RED", "FULL", "WEDGE"] call CBA_fnc_addWaypoint;
private _data = _this getVariable ["dsm_garrisonData", []];
{
	_this reveal _x;
} foreach ({(getPos _x) inArea _data} count (allPlayers select {side _x == blufor}));

