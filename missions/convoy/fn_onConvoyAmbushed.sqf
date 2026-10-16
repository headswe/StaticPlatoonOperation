// Ambush reaction: the troops in the supply trucks dismount and fight as a new group,
// the vehicles speed up and push through towards the exit.
_this setVariable ["spo_convoy_ambushed", true];
private _grp = _this getVariable ["spo_convoy_group", grpNull];
private _dismounts = [];
{
	private _veh = _x;
	{
		_x params ["_unit", "_role"];
		if (_role == "cargo" && {alive _unit}) then { _dismounts pushBack _unit; };
	} forEach (fullCrew _veh);
} forEach ((_this getVariable ["spo_convoy_supply", []]) select {alive _x});
if (_dismounts isNotEqualTo []) then {
	private _squad = createGroup [east, true];
	_dismounts joinSilent _squad;
	{
		unassignVehicle _x;
		[_x] allowGetIn false;
		doGetOut _x;
		_x enableAI "AUTOCOMBAT";
	} forEach _dismounts;
	private _enemy = (leader _squad) findNearestEnemy (leader _squad);
	private _target = if (isNull _enemy) then { getPos leader _squad } else { getPos _enemy };
	[_squad, _target, false] call spo_fnc_attackPoint;
	spo_patrol_groups pushBack _squad;
};
_grp setBehaviour "AWARE";
_grp setSpeedMode "FULL";
_grp setCombatMode "RED";
_this setVariable ["spo_convoy_speed", 75];
["Convoy ambushed, pushing through"] call spo_fnc_log;
