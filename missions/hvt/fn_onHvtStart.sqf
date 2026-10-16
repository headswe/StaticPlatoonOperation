// HVT mission start (_this = spo_namespace). Officer plus bodyguards in a building, an empty car parked nearby.
([spo_centerPos, spo_objective_radius] call spo_fnc_nearBuildings) params ["_buildings"];
_buildings = _buildings select {count (_x # 0) >= 4};
// prefer a building the regular garrison left empty
private _empty = _buildings select {isNull ((_x # 1) getVariable ["spo_garrison_group", grpNull])};
if (_empty isNotEqualTo []) then { _buildings = _empty; };

private _building = objNull;
private _poses = [];
if (_buildings isEqualTo []) then {
	private _spot = spo_centerPos findEmptyPosition [0, spo_objective_radius, "Land_Cargo_House_V1_F"];
	if (_spot isEqualTo []) then { _spot = spo_centerPos; };
	_building = "Land_Cargo_House_V1_F" createVehicle _spot;
	_poses = _building buildingPos -1;
} else {
	(selectRandom _buildings) params ["_buildingPoses", "_selected"];
	_building = _selected;
	_poses = +_buildingPoses;
};
if (_poses isEqualTo []) then { _poses = [getPos _building]; };
[_poses, true] call CBA_fnc_shuffle;

private _grp = createGroup [east, true];
_grp setBehaviour "SAFE";
private _spawn = {
	params ["_role", "_pos"];
	private _unit = _grp createUnit ['O_Soldier_F', [0, 0, 0], [], 0, 'NONE'];
	[_unit, selectRandom spo_speakers] remoteExec ["setIdentity", 0, _unit];
	_unit setPos _pos;
	[_unit, _role] call spo_fnc_gear;
	_unit disableAI "PATH";
	_unit setUnitPos "UP";
	_unit
};
private _hvt = ["co", _poses # 0] call _spawn;
_hvt setRank "COLONEL";
_grp selectLeader _hvt;
for "_i" from 1 to ((count _poses - 1) min (3 + floor random 3)) do {
	[selectRandom spo_allowedRoles, _poses # _i] call _spawn;
};

// escape car: a transport from the vehicle faction if allowed, otherwise a civilian SUV
private _carClass = "C_SUV_01_F";
if (spo_vehicleFaction != "") then {
	private _cars = (call spo_fnc_getTransportVehicle) select {([_x] call spo_fnc_vehicleCategory) isEqualTo "car"};
	if (_cars isNotEqualTo []) then { _carClass = configName (selectRandom _cars); };
};
private _roads = (getPos _building) nearRoads 80;
private _carPos = if (_roads isEqualTo []) then {
	(getPos _building) findEmptyPosition [8, 60, _carClass]
} else {
	getPos (selectRandom _roads)
};
private _car = objNull;
if (_carPos isNotEqualTo []) then {
	_car = createVehicle [_carClass, _carPos, [], 0, "NONE"];
	_car lock 0;
};

// the escape route ends at the road entry farthest from the building
private _exits = spo_reinforcement_locations apply {[_x distance2D _building, _x]};
_exits sort false;
private _escapePos = if (_exits isEqualTo []) then { spo_centerPos getPos [spo_perimeter_radius + 300, random 360] } else { (_exits # 0) # 1 };

// players get a rough area, not the exact building
private _taskPos = (getPos _building) getPos [random 60, random 360];
private _task = [blufor, "spo_hvt_task", ["Capture the enemy commander and bring him out of the area (the blue ring). Killing him is acceptable but intel is lost. He will run for a vehicle if he hears you coming.", "Capture or kill the HVT", ""], _taskPos, "AUTOASSIGNED", 0, true, "kill"] call BIS_fnc_taskCreate;

_this setVariable ["spo_hvt", _hvt];
_this setVariable ["spo_hvt_group", _grp];
_this setVariable ["spo_hvt_car", _car];
_this setVariable ["spo_hvt_escapePos", _escapePos];
_this setVariable ["spo_hvt_task", _task];
