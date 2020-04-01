private _patrolsGrps = dsm_patrol_groups select {(isNull (_x getVariable ["dsm_reinforceing", grpNull])) && _x != _this} apply {[(leader _this) distance (leader _x), _x]};
_patrolsGrps sort true;
if(count _patrolsGrps > 0) then {
	(_patrolsGrps#0) params ["_distance", "_patrol"];
	systemChat format ["distance %1", _distance];
	_patrol setVariable ["dsm_reinforceing", _this];
	_this setVariable ["dsm_reinforcement_called", time];
};
systemChat "group requrest reinforcement";