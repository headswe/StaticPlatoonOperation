private _task = _this getVariable ["spo_secure_task", nil];
[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
["The site is secure and the counter-attack has been beaten off."] call spo_fnc_objectiveComplete;
