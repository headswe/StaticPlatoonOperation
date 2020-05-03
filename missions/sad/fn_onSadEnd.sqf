private _task = _this getVariable ["spo_sad_task", nil];
[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;