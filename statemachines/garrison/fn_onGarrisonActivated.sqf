{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach units _this;
_this call spo_fnc_requestReinforcement;
[_this] call CBA_fnc_clearWaypoints;
private _wp = [_this, _this, 0, "SAD", "AWARE", "RED", "FULL", "WEDGE"] call CBA_fnc_addWaypoint;
private _data = _this getVariable ["spo_garrisonData", []];
{
	_this reveal _x;
} foreach ((playableUnits + switchableUnits) select {side _x == blufor && (getPos _x) inArea _data});

