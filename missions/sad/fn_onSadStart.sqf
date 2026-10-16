
private _task = [blufor, "spo_sad_task", ["Search and destroy","Search and destroy", ""], spo_centerPos, "AUTOASSIGNED", 0, true, "attack"] call BIS_fnc_taskCreate;
_this setVariable ["spo_sad_task",_task];
_this setVariable ["spo_enemyCount", count (units east) * 0.15];
