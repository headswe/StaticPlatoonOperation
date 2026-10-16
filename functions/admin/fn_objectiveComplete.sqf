// Server: a mission's objective is done. The mission keeps running, admins are asked whether to end it.
params [["_message", ""]];
if (!isServer) exitWith {};
spo_objectiveCompleteMsg = _message;
publicVariable "spo_objectiveCompleteMsg";
[_message] remoteExec ["spo_fnc_promptAdminEnd", 0, "spo_endPrompt"];
