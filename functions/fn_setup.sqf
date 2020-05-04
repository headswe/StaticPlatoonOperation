private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if(count spo_reinforcement_locations <= 0) then {
	spo_reinforcement_locations pushBack ([spo_perimeter_mkrName, true] call CBA_fnc_randPosArea);
};
// total manpower of the enemy faction
spo_ai_manpower = round (5 + (_playerCount * spo_aiRatio));
// we only allow 180 to be spawned as garrison + patrols
spo_ai_initialManpower =  spo_ai_manpower min 180; // spawn max(ish) 180 ai
spo_ai_manpower = (spo_ai_manpower - spo_ai_initialManpower) max 0;

spo_vehiclePoints = 0;
{
	private _role = _x getVariable ["tmf_assignGear_role",'r'];
	if(_role isEqualTo 'rat') then {
		spo_vehiclePoints = spo_vehiclePoints + 1;
	};
	if(_role isEqualTo 'matg') then {
		spo_vehiclePoints = spo_vehiclePoints + 2;
	};
	if(_role isEqualTo 'hatg') then {
		spo_vehiclePoints = spo_vehiclePoints + 3;
	};
} foreach (playableUnits + switchableUnits);

// why do i do this?
{
	[_x] remoteExec ["spo_fnc_gear", _x];
	[] remoteExec ["TMF_acre2_fnc_clientInit", _x];
} foreach (allUnits select {side _x == blufor});

spo_overwatch_locations = [];

// Spawn garrison
_garrisonUnits = round (spo_ai_initialManpower* random [0.3,0.35,0.4]);
([spo_centerPos, _garrisonUnits, spo_objective_radius*(random [1,1.2,1.5])] call spo_fnc_createGarrison) params ['_spawnedUnits', '_garrisonGrps'];
spo_garrison_groups = _garrisonGrps;
spo_garrison_units = _spawnedUnits;
spo_ai_initialManpower = spo_ai_initialManpower - count _spawnedUnits;
spo_patrol_groups = [];

// Spawn guards	
_directions = [0, 90, 180, 270];
[_directions, true] call CBA_fnc_shuffle;

{
	_spawnPos = spo_centerPos getPos [spo_objective_radius*2, _x];
	_spawnPos = ((selectBestPlaces [_spawnPos, 100, "(1 - forest) * (0.5 * trees) * (5 * hills)", 1, 1]) # 0) # 0;
	if(surfaceIsWater _spawnPos) then {
		_spawnPos = ((selectBestPlaces [_spawnPos, 750, "(1 - forest) * (0.5 * trees) * (5 * hills)", 1, 1]) # 0) # 0;
	};
	[_spawnPos] call spo_fnc_createGuardPoint;
} foreach _directions;

// patrol time
private _alt = 0;
private _patrolDir = random [-180, 0, 360];
while {spo_ai_initialManpower > 0} do {
	private _numberOfMen = (random [3,5,6]) min (spo_ai_initialManpower);
	private _spawnPos = spo_centerPos getpos [random [spo_objective_radius, spo_perimeter_radius / 3, spo_perimeter_radius] , _patrolDir];
	if(surfaceIsWater _spawnPos) then {
		_spawnPos = ((selectBestPlaces [_spawnPos, 500, "(1 - sea)", 1, 1]) # 0) # 0;
	};
	[_numberOfMen, _spawnPos, _patrolDir] call spo_fnc_createPatrol;
	_patrolDir = _patrolDir + (random [0, 90, 180]);
};
// Vehicles
if(spo_vehicleFaction != '') then {
	private _numberOfVehicles = random [1, round (spo_vehiclePoints / 2), spo_vehiclePoints];
	for "_i" from 1 to _numberOfVehicles do { 
		if(_i == 1) then {
			private _createdVeh = [spo_centerPos, 'combat'] call spo_fnc_createVehicle;
			[group (effectiveCommander _createdVeh),spo_centerPos, 1, 4, spo_objective_radius, true] call spo_fnc_patrol;
		} else {
			private _firstPos = selectRandom spo_reinforcement_locations;
			private _secondPos = selectRandom (spo_reinforcement_locations - [_firstPos]);
			_firstPos set [2,0];
			_secondPos set [2,0];
			private _createdVeh = [_firstPos, 'combat'] call spo_fnc_createVehicle;
			private _wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp = [group (effectiveCommander _createdVeh), _secondPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "CYCLE"] call CBA_fnc_addWaypoint;
			spo_patrol_groups pushBack (group (effectiveCommander _createdVeh));
		}
	};
};

AI_SPAWNED = true;

spo_mission_object = call CBA_fnc_createNamespace;
spo_alert_triggerd = 0;
spo_patrol_statemachine = [(missionconfigfile >> "SPO_PatrolStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
spo_garrison_statemachine = [(missionconfigfile >> "SPO_GarrisonStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
spo_mission_statemachine = [(missionconfigfile >> "SPO_Missions" >> "SPO_Secure_MissionStateMachine")] call CBA_statemachine_fnc_createFromConfig; 


private _enemyFactionMsg = format ["Enemy Faction: %1", getText (configFile >> "CfgLoadouts" >> spo_opforFaction >> "displayName")];
_enemyFactionMsg remoteExec ["systemChat"];