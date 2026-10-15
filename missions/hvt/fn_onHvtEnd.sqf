// HVT outcome: "extracted" (full success), "killed" (partial) or "escaped" (failed). The admin decides when to end.
params ["_outcome"];
private _task = spo_namespace getVariable ["spo_hvt_task", ""];
switch (_outcome) do {
	case "extracted": {
		[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
		["The HVT has been captured and extracted."] call spo_fnc_objectiveComplete;
	};
	case "killed": {
		[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
		["The HVT is dead. No intel, but he won't be giving orders."] call spo_fnc_objectiveComplete;
	};
	case "escaped": {
		[_task, "FAILED"] call BIS_fnc_taskSetState;
		["The HVT got away."] call spo_fnc_objectiveComplete;
	};
};
