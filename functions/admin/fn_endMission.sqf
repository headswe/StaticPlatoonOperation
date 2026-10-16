// Server: end the mission for everyone. Only admins may trigger it.
if (!isServer || {!(call spo_fnc_isAdminCaller)}) exitWith {};
["END1", true] call BIS_fnc_endMissionServer;
