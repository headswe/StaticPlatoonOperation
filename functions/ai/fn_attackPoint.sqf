params ["_grp", "_location", "_hasVehicles"];
[_grp] call CBA_fnc_clearWaypoints;
private _wp = [_grp, _grp, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [3,3,3], 0] call CBA_fnc_addWaypoint;
private _dirTo = _location getDir (getPos leader _grp);
if(_hasVehicles) then {
    _wp = [_grp, (_location getPos [200, _dirTo]) , 0, "UNLOAD", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
    _wp = [_grp, _location, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 0] call CBA_fnc_addWaypoint;
} else {
    _wp = [_grp, (_location getPos [200, _dirTo]) , 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
    _wp = [_grp, _location, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 0] call CBA_fnc_addWaypoint;
};