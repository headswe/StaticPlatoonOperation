{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach units _this;
_this call dsm_fnc_requestReinforcement;
private _wp = _this addWaypoint [getPos (leader _this), -1];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 300;
_wp setWaypointType "SAD";
_wp setWaypointCompletionRadius 300;
