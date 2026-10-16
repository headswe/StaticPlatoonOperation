private _task = _this getVariable ["spo_sad_task", nil];
[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
[] call spo_fnc_hunt;
["Most of the enemy force is down; the survivors are hunting you."] call spo_fnc_objectiveComplete;
