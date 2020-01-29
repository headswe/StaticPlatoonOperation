private _spawnPos = selectRandom dsm_reinforcement_locations;
if(dsm_vehicleFaction == '') exitWith {
 objNull
};
private _createdVeh = objNull;
_createdVeh = [dsm_centerPos, 'combat', true] call dsm_fnc_createVehicle;
private _grp = group effectiveCommander _createdVeh;
// waypoint
private _wp = _grp addWaypoint [getpos leader _grp, -1];
_wp setWaypointCompletionRadius 100;
_wp setWaypointTimeout  [3,6,9];
_wp = _grp addWaypoint [getpos leader _grp, -1];
_wp setWaypointCompletionRadius 100;
_wp setWaypointBehaviour "AWARE";
_wp setWaypointSpeed "FULL";
_wp setWaypointPosition (getpos leader _grp);
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 100;
_wp = _grp addWaypoint [dsm_centerPos, -1];
_wp setWaypointType "SAD";
_wp setWaypointCompletionRadius 100;