// The HVT is handcuffed: stop his escape and switch the task to extraction.
private _hvt = _this getVariable ["spo_hvt", objNull];
[group _hvt] call CBA_fnc_clearWaypoints;
[_hvt] joinSilent createGroup [east, true];
[_this getVariable ["spo_hvt_task", ""], ["Bring the captured HVT out of the area (past the blue ring).", "Extract the HVT", ""]] call BIS_fnc_taskSetDescription;
[_this getVariable ["spo_hvt_task", ""], spo_centerPos getPos [spo_perimeter_radius, 0]] call BIS_fnc_taskSetDestination;
