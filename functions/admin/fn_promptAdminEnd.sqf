// Client: offer admins an "End mission" action once the objective is complete.
params ["_message"];
if (!hasInterface) exitWith {};

[{!isNull player}, {
	params ["_message"];
	if (serverCommandAvailable "#kick") then { [true] call spo_fnc_onAdminChanged; };

	if (!isNil "spo_endMissionAction") exitWith {};
	private _addAction = {
		spo_endMissionAction = player addAction [
			"<t color='#ff5555'>End mission</t>",
			{ [] remoteExecCall ["spo_fnc_endMission", 2]; },
			[], 0, false, true, "", "serverCommandAvailable '#kick'"
		];
	};
	call _addAction;
	// actions are lost on respawn
	player addEventHandler ["Respawn", _addAction];
}, [_message]] call CBA_fnc_waitUntilAndExecute;
