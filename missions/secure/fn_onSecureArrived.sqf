private _building = _this getVariable ["spo_secure_building", nil];
private _task = _this getVariable ["spo_secure_task", nil];
[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
private _task = [blufor, "spo_secure_task_2", ["Defend the site","Gotta defend dude", ""], getpos _building, "AUTOASSIGNED", 0, true, "defend"] call BIS_fnc_taskCreate;
_this setVariable ["spo_secure_task", _task];

_manpower = spo_ai_manpower * 0.3;
spo_attack_wave = [];
while {_manpower > 0} do {
	private _spawnPos = selectRandom spo_reinforcement_locations;

	private _numOfUnits = (random [2, 4, 6]) min _manpower;
	_manpower = _manpower - _numOfUnits;
	private _grp = [_spawnPos, _numOfUnits] call spo_fnc_createSquad;
	_grp setCombatMode "RED";
	_grp allowFleeing 0;
	[_grp] call CBA_fnc_clearWaypoints;
	private _wp = [_grp, _grp, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 0] call CBA_fnc_addWaypoint;
	_wp = [_grp, _grp, 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 100] call CBA_fnc_addWaypoint;
	_grp setCurrentWaypoint _wp;
	_wp = [_grp, (getpos _building), 0, "MOVE", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;
	_wp = [_grp, (getpos _building), 0, "SAD", "AWARE", "RED", "FULL", "WEDGE","", [0,0,0], 200] call CBA_fnc_addWaypoint;

	spo_attack_wave pushBackUnique _grp;
};