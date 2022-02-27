private _building = _this getVariable ["spo_secure_building", nil];
private _task = _this getVariable ["spo_secure_task", nil];
[_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
private _task = [blufor, "spo_secure_task_2", ["Defend the site","Defend it soldier!", ""], getpos _building, "AUTOASSIGNED", 0, true, "defend"] call BIS_fnc_taskCreate;
_this setVariable ["spo_secure_task", _task];

_manpower = spo_ai_manpower * 0.6;
spo_attack_wave = [];
while {_manpower > 0} do {
	private _spawnPos = selectRandom spo_reinforcement_locations;
	private _hasVehicles = false;
	private _veh = objNull;
	if(spo_vehicleFaction != '' && (random 1) >= 0.65) then {
		_veh = [_spawnPos, "transport"] call spo_fnc_createVehicle;
		_hasVehicles = true;
	};
	private _numOfUnits = (random [2, 4, 6]) min _manpower;
	_manpower = _manpower - _numOfUnits;
	private _grp = [_spawnPos, _numOfUnits] call spo_fnc_createSquad;
	spo_attack_wave pushBackUnique _grp;
	if(_hasVehicles) then {
		if(!isNull _veh) then {
			private _soldiers = (units _grp);
			_soldiers joinSilent (leader _veh);
			{ _x moveInAny _veh } forEach _soldiers;
			_grp = group _veh;
		} else {
			_hasVehicles = false;
		}; 
	};
	[_grp, getPos _building, _hasVehicles] call spo_fnc_attackPoint;
};

{
	private _grp = _x;
    {
        _x enableAI "PATH";
        _x setUnitPos "AUTO";
    } forEach units _grp;
	[_grp, getPos _building, false] call spo_fnc_attackPoint;
    
} forEach spo_garrison_groups;

{
	private _grp = _x;
	[_grp, getPos _building, false] call spo_fnc_attackPoint;
} forEach spo_patrol_groups;

