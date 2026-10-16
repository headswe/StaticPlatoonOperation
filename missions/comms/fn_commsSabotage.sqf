// Server, from the tower's hold action: arm a 20 second fuse, then destroy the tower.
params [["_tower", objNull, [objNull]]];
if (!alive _tower || {_tower getVariable ["spo_comms_charged", false]}) exitWith {};
_tower setVariable ["spo_comms_charged", true, true];
"Charge set on the transmitter. 20 seconds!" remoteExec ["hint", 0];
[{
	params ["_tower"];
	"HelicopterExploSmall" createVehicle (getPos _tower);
	_tower setDamage 1;
	// some terrain/mod towers can't be destroyed; the mission counts the charge either way
	spo_commsDown = true;
}, [_tower], 20] call CBA_fnc_waitAndExecute;
