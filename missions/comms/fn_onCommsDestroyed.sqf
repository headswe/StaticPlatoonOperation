// Tower down: no more waves, no more reinforcement calls between patrols, and the enemy's nerve breaks a little.
spo_commsDown = true;
[_this getVariable ["spo_comms_task", ""], "SUCCEEDED"] call BIS_fnc_taskSetState;
{
	if (!isNull _x) then {
		_x allowFleeing 0.4;
		{ _x setSkill ["courage", 0.2]; _x setSkill ["commanding", 0.1]; } forEach units _x;
	};
} forEach (spo_patrol_groups + spo_garrison_groups);
"The comms tower is down. Enemy radio traffic has gone quiet." remoteExec ["hint", 0];
["Comms tower destroyed. Enemy reinforcements have stopped."] call spo_fnc_objectiveComplete;
