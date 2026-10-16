// Comms mission start (_this = spo_namespace): a radio tower with a guard post near the objective.
private _towerClass = "Land_TTowerBig_2_F";
private _places = selectBestPlaces [spo_centerPos, spo_objective_radius, "meadow + 2 * hills - 3 * houses - 5 * sea", 25, 10];
private _pos = [];
{
	_pos = (_x # 0) findEmptyPosition [0, 25, _towerClass];
	if (_pos isNotEqualTo []) exitWith {};
} forEach _places;
if (_pos isEqualTo []) then { _pos = spo_centerPos findEmptyPosition [0, spo_objective_radius, _towerClass]; };
if (_pos isEqualTo []) then { _pos = +spo_centerPos; };

private _tower = createVehicle [_towerClass, _pos, [], 0, "CAN_COLLIDE"];
private _generator = createVehicle ["Land_PowerGenerator_F", _tower getPos [6, random 360], [], 0, "NONE"];
_generator allowDamage false;
[_pos] call spo_fnc_createGuardPoint;

// sabotage: a 10 s hold action at the tower base on every client (JIP-safe, removed with the tower)
[
	_tower, "Plant charge on the transmitter",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_destroy_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_destroy_ca.paa",
	"alive _target && {_this distance2D _target < 10} && {!(_target getVariable ['spo_comms_charged', false])}",
	"alive _target && {_this distance2D _target < 10}",
	{}, {}, { [_target] remoteExecCall ["spo_fnc_commsSabotage", 2]; }, {},
	[], 10, 10, true, false
] remoteExec ["BIS_fnc_holdActionAdd", 0, _tower];

private _task = [blufor, "spo_comms_task", ["The enemy is directing reinforcements through a radio tower near the objective. As long as it stands and they know you are there, fresh squads will keep arriving from the roads. Destroy it or plant a charge on the transmitter.", "Destroy the comms tower", ""], _tower, "AUTOASSIGNED", 0, true, "destroy"] call BIS_fnc_taskCreate;

spo_commsDown = false;
_this setVariable ["spo_comms_tower", _tower];
_this setVariable ["spo_comms_task", _task];
_this setVariable ["spo_comms_nextWave", time + 60];
// waves draw from what's left of the enemy manpower, plus half again, so the tower can't spawn forever
_this setVariable ["spo_comms_budget", spo_ai_manpowerRemaining + round (spo_ai_manpower * 0.5)];
