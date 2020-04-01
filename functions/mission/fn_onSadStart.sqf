
private _task = [blufor, "dsm_sad_task", ["Search and destroy","Search and destroy", ""], dsm_centerPos, "AUTOASSIGNED", 0, true, "attack"] call BIS_fnc_taskCreate;
_this setVariable ["dsm_sad_task",_task];
_this setVariable ["dsm_enemyCount", count (allUnits select {side _x == EAST})* 0.20];