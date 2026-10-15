// The convoy rolls: MOVE waypoints along the route, column formation, capped speed.
private _grp = _this getVariable ["spo_convoy_group", grpNull];
(_this getVariable ["spo_convoy_route", []]) params ["_via", "_end"];
[_grp] call CBA_fnc_clearWaypoints;
private _wp = _grp addWaypoint [_via, 0];
_wp setWaypointType "MOVE";
_wp setWaypointFormation "COLUMN";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointCompletionRadius 30;
_wp = _grp addWaypoint [_end, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 30;
// keep to the road: off-road shortcuts are what break vanilla convoys apart
(vehicle leader _grp) forceFollowRoad true;
"The enemy convoy is on the move." remoteExec ["hint", 0];
["Convoy departed"] call spo_fnc_log;
