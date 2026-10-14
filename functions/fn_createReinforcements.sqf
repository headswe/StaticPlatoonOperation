private _spawnPos = selectRandom spo_reinforcement_locations;
if(spo_vehicleFaction == '') exitWith {
 objNull
};
private _createdVeh = objNull;
_createdVeh = [_spawnPos, 'combat', true] call spo_fnc_createVehicle;
if(isNull _createdVeh) then {
	_createdVeh = [_spawnPos, 'transport', true] call spo_fnc_createVehicle;
};
if (isNull _createdVeh) exitWith { objNull };
private _grp = group effectiveCommander _createdVeh;
// waypoint
private _wp = _grp addWaypoint [getPos leader _grp, 0];
_wp setWaypointCompletionRadius 100;
_wp setWaypointTimeout  [3,6,9];
_wp = _grp addWaypoint [getPos leader _grp, 0];
_wp setWaypointCompletionRadius 100;
_wp setWaypointBehaviour "AWARE";
_wp setWaypointSpeed "FULL";
_wp setWaypointPosition (getPos leader _grp);
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 100;
_wp = _grp addWaypoint [spo_centerPos, 0];
_wp setWaypointType "SAD";
_wp setWaypointCompletionRadius 100;
