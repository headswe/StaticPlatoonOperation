
private _task = [blufor, "spo_sad_task", ["Search and destroy","Search and destroy", ""], spo_centerPos, "AUTOASSIGNED", 0, true, "attack"] call BIS_fnc_taskCreate;
_this getVariable ["spo_sad_task",_task];
_this getVariable ["spo_enemyCount", count (allUnits select {side _x == EAST})* 0.15];
