// One reinforcement wave called in over the tower: a squad, sometimes in a truck, from a road entry.
private _tower = _this getVariable ["spo_comms_tower", objNull];
private _budget = _this getVariable ["spo_comms_budget", 0];
_this setVariable ["spo_comms_nextWave", time + 120 + random 90];

private _spawnPos = selectRandom spo_reinforcement_locations;
_spawnPos = [_spawnPos # 0, _spawnPos # 1, 0];
private _numOfUnits = round ((random [4, 6, 8]) min _budget);
_this setVariable ["spo_comms_budget", _budget - _numOfUnits];
private _grp = [_spawnPos, _numOfUnits] call spo_fnc_createSquad;
private _hasVehicle = false;
if (spo_vehicleFaction != "" && {random 1 < 0.4}) then {
	private _veh = [_spawnPos, "transport"] call spo_fnc_createVehicle;
	if (!isNull _veh) then {
		private _vehGrp = group effectiveCommander _veh;
		private _soldiers = units _grp;
		_soldiers joinSilent _vehGrp;
		{ _x moveInAny _veh } forEach _soldiers;
		_grp = _vehGrp;
		_hasVehicle = true;
	};
};
// they head for the fight: the nearest known player, otherwise the tower
private _target = getPos _tower;
private _contact = (spo_patrol_groups select {!isNull _x && {alive leader _x}}) apply {(leader _x) findNearestEnemy (leader _x)} select {!isNull _x};
if (_contact isNotEqualTo []) then { _target = getPos (selectRandom _contact); };
[_grp, _target, _hasVehicle] call spo_fnc_attackPoint;
spo_patrol_groups pushBack _grp;

// let the players hear it: a flare over the entry road and a radio intercept with the direction
[_spawnPos getPos [50, _spawnPos getDir spo_centerPos], 150] call spo_fnc_createFlare;
private _dirs = ["north", "north-east", "east", "south-east", "south", "south-west", "west", "north-west"];
private _dir = _dirs # ((round ((spo_centerPos getDir _spawnPos) / 45)) mod 8);
format ["Radio intercept: enemy reinforcements inbound from the %1%2.", _dir, ["", " with vehicles"] select _hasVehicle] remoteExec ["hint", 0];
[format ["Comms wave of %1 from %2, budget left %3", _numOfUnits, _dir, _this getVariable "spo_comms_budget"]] call spo_fnc_log;
