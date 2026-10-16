// Client: called whenever this machine gains or loses admin rights.
params ["_isAdmin"];

if (_isAdmin) then {
	// Map clicks pick the objective until the mission has been set up.
	if (isNil "spo_click_action" && {!(missionNamespace getVariable ["spo_aiSpawned", false])}) then {
		spo_click_action = addMissionEventHandler ["MapSingleClick", {
			params ["_units", "_pos", "_alt", "_shift"];
			[[_pos#0, _pos#1, 0]] remoteExecCall ['spo_fnc_setObjective', 2];
		}];
	};
	if (!isNil "spo_objectiveCompleteMsg") then {
		hint parseText format ["<t size='1.3'>Objective complete</t><br/>%1<br/><br/>Use the <t color='#ff5555'>End mission</t> action when you are ready.", spo_objectiveCompleteMsg];
	};
} else {
	if (!isNil "spo_click_action") then {
		removeMissionEventHandler ["MapSingleClick", spo_click_action];
		spo_click_action = nil;
	};
};
