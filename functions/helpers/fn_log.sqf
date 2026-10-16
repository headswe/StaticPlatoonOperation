// Debug output to the RPT and system chat, only when spo_debug is true (set it from the debug console).
params ["_message"];
if !(missionNamespace getVariable ["spo_debug", false]) exitWith {};
diag_log text format ["[SPO] %1", _message];
systemChat _message;
