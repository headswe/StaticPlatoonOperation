// Convoy outcome: "stopped" (every supply truck is out) or "escaped" (one reached the exit). The admin decides when to end.
params ["_outcome"];
private _task = spo_namespace getVariable ["spo_convoy_task", ""];
{ deleteMarker _x; } forEach ["spo_convoy_start", "spo_convoy_end"];
if (_outcome == "stopped") then {
	[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
	["The supply convoy has been stopped."] call spo_fnc_objectiveComplete;
} else {
	[_task, "FAILED"] call BIS_fnc_taskSetState;
	"A supply truck got through." remoteExec ["hint", 0];
	["The convoy got a supply truck through."] call spo_fnc_objectiveComplete;
};
