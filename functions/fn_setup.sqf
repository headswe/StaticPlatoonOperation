private _playerCount = (count (playableUnits + switchableUnits)) max 1;
dsm_aiRatioCount =  round ((5 + (_playerCount * dsm_aiRatio) ) min 180);

{
	[_x] remoteExec ["dsm_fnc_gear", _x];
	[] remoteExec ["TMF_acre2_fnc_clientInit", _x];
} foreach (allUnits select {side _x == blufor});


// Spawn garrison
_garrisonUnits = round (dsm_aiRatioCount* random [0.3,0.35,0.4]);
([dsm_centerPos, _garrisonUnits, dsm_objective_radius*(random [1,1.2,1.5])] call dsm_fnc_createGarrison) params ['_spawnedUnits', '_garrisonGrps'];
dsm_garrison_groups = _garrisonGrps;
dsm_garrison_units = _spawnedUnits;
dsm_aiRatioCount = dsm_aiRatioCount - count _spawnedUnits;
dsm_patrol_groups = [];

// Spawn guards	
_directions = [random 90, random 90 + 90, random 90 + 180, random 90 + 270];
[_directions, true] call CBA_fnc_shuffle;

{
	_spawnPos = dsm_centerPos getPos [(random dsm_perimeter_radius max dsm_objective_radius), _x];
	if(surfaceIsWater _spawnPos) then {
		_spawnPos = ((selectBestPlaces [_spawnPos, 750, "forest + trees  - meadow - houses - (10 * sea)", 1, 1]) # 0) # 0
	};
	[_spawnPos] call dsm_fnc_createGuardPoint;
} foreach _directions;

// patrol time
while {dsm_aiRatioCount > 0} do {
	private _numberOfMen = (random [3,5,6]) min (dsm_aiRatioCount);
	_patrolDir = random 360;
	private _spawnPos = dsm_centerPos getpos [(dsm_objective_radius+(random dsm_perimeter_radius)) min dsm_perimeter_radius , _patrolDir];
	if(surfaceIsWater _spawnPos) then {
		_spawnPos = ((selectBestPlaces [_spawnPos, 750, "forest + trees  - meadow - houses - (10 * sea)", 1, 1]) # 0) # 0;
	};
	[_numberOfMen, _spawnPos, _patrolDir] call dsm_fnc_createPatrol;
};
// Vehicles
if(dsm_vehicleFaction != '') then {
	private _numberOfAT = {(_x getVariable ["tmf_assignGear_role",'r']) isEqualTo 'rat'} count (playableUnits + switchableUnits);
	private _numberOfVehicles = 0;
	if(_numberOfAT > 0) then {
		_numberOfVehicles = (round (random _numberOfAT)) max 1;
	};
	for "_i" from 1 to _numberOfVehicles do { 
		if(_i == 1) then {
			private _createdVeh = [dsm_centerPos, 'combat'] call dsm_fnc_createVehicle;
			[group (effectiveCommander _createdVeh),dsm_centerPos, 1, 4, dsm_objective_radius, true] call dsm_fnc_patrol;
		} else {
			private _firstPos = selectRandom dsm_reinforcement_locations;
			private _secondPos = selectRandom (dsm_reinforcement_locations - [_firstPos]);
			_firstPos set [2,0];
			_secondPos set [2,0];
			private _createdVeh = [_firstPos, 'combat'] call dsm_fnc_createVehicle;
			private _wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp = [group (effectiveCommander _createdVeh), _secondPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "CYCLE"] call CBA_fnc_addWaypoint;
			dsm_patrol_groups pushBack (group (effectiveCommander _createdVeh));
		}
	};
};

AI_SPAWNED = true;

dsm_mission_object = call CBA_fnc_createNamespace;
dsm_alert_triggerd = 0;
dsm_patrol_statemachine = [(missionconfigfile >> "SPO_PatrolStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
dsm_garrison_statemachine = [(missionconfigfile >> "SPO_GarrisonStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
dsm_mission_statemachine = [(missionconfigfile >> "SPO_SAD_MissionStateMachine")] call CBA_statemachine_fnc_createFromConfig; 