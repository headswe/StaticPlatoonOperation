systemChat "Group responding to ReinforcementRequest";
private _grp = _this;
private _groupToReinforce = _grp getVariable ["spo_reinforceing", grpNull];
_grp setVariable ["spo_reinforcement_location", getPosATL leader _groupToReinforce];

[_grp] call CBA_fnc_clearWaypoints;
private _wp = [_grp, _grp, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 0] call CBA_fnc_addWaypoint;
_wp = [_grp, _grp, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 100] call CBA_fnc_addWaypoint;
_grp setCurrentWaypoint _wp;
_wp = [_grp, _groupToReinforce, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
_wp = [_grp, _groupToReinforce, 0, "SAD", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
_wp = [_grp, _groupToReinforce, 0, "SAD", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
_wp = _grp addWaypoint [getPosATL leader _groupToReinforce, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true", "(this) setVariable ['spo_reinforceing', grpNull]"];
_wp setWaypointCompletionRadius 50;