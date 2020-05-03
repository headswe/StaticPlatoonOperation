private _patrolsGrps = spo_patrol_groups select {(isNull (_x getVariable ["spo_reinforceing", grpNull])) && _x != _this} apply {[(leader _this) distance (leader _x), _x]};
_patrolsGrps sort true;
if(count _patrolsGrps > 0) then {
	(_patrolsGrps#0) params ["_distance", "_patrol"];
	systemChat format ["distance %1", _distance];
	_patrol setVariable ["spo_reinforceing", _this];
	_this setVariable ["spo_reinforcement_called", time];
};
systemChat "group requrest reinforcement";