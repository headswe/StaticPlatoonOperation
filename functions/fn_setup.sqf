// only admins may run setup, and only once
if (!(call spo_fnc_isAdminCaller) || {spo_aiSpawned}) exitWith {};
if (isNil "spo_perimeter_mkrName") exitWith {
	"Click the map to pick an objective before pressing Go." remoteExec ["hint", [remoteExecutedOwner, 0] select (remoteExecutedOwner == 0)];
};
// settings from the setup dialog: [player faction, enemy faction, AI ratio, vehicle faction, mission, hour (-1 keep), weather preset (-1 keep), vehicle types]
params [["_settings", [], [[]]]];
_settings params [
	["_bluFaction", spo_bluFaction, [""]],
	["_opforFaction", spo_opforFaction, [""]],
	["_aiRatio", spo_aiRatio, [0]],
	["_vehicleFaction", spo_vehicleFaction, [""]],
	["_mission", spo_missionClassName, [""]],
	["_hour", -1, [0]],
	["_weather", -1, [0]],
	["_vehicleTypes", spo_vehicleTypes, [[]]]
];
if (isClass (configFile >> "CfgLoadouts" >> _bluFaction)) then { spo_bluFaction = _bluFaction; };
if (isClass (configFile >> "CfgLoadouts" >> _opforFaction)) then { spo_opforFaction = _opforFaction; };
spo_aiRatio = 2 max _aiRatio min 58;
spo_vehicleFaction = _vehicleFaction;
spo_vehicleTypes = _vehicleTypes select {_x in ["car", "apc", "tank", "heli"]};
if (!isClass (missionConfigFile >> "SPO_Missions" >> _mission)) then {
	_mission = configName (("true" configClasses (missionConfigFile >> "SPO_Missions")) # 0);
};
spo_missionClassName = _mission;
{ publicVariable _x; } forEach ["spo_bluFaction", "spo_opforFaction", "spo_aiRatio", "spo_vehicleFaction", "spo_vehicleTypes", "spo_missionClassName"];

if (_hour >= 0) then {
	private _date = date;
	_date set [3, _hour min 23];
	_date set [4, 0];
	[_date, true] call BIS_fnc_setDate;
};
if (_weather >= 0) then { [_weather min 8] call spo_fnc_setWeather; };

spo_aiSpawned = true;
publicVariable "spo_aiSpawned";

// connected players only: empty or AI-filled lobby slots would inflate the enemy force
private _playerCount = (count (allPlayers - entities "HeadlessClient_F")) max 1;
if(count spo_reinforcement_locations <= 0) then {
	spo_reinforcement_locations pushBack ([spo_perimeter_mkrName, true] call CBA_fnc_randPosArea);
};
// total manpower of the enemy faction
spo_ai_manpower = round (5 + (_playerCount * spo_aiRatio));
// we only allow 180 to be spawned as garrison + patrols
spo_ai_initialManpower =  spo_ai_manpower min 180; // spawn max(ish) 180 ai
spo_ai_manpowerRemaining = (spo_ai_manpower - spo_ai_initialManpower) max 0;

enemyDoll setVariable ["tmf_assignGear_faction", spo_opforFaction];
enemyDoll setVariable ["tmf_assignGear_role","r"];
enemyDoll call tmf_assignGear_fnc_assignGear;

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
} forEach (allPlayers - entities "HeadlessClient_F");

// why do i do this?
{
	[_x] remoteExec ["spo_fnc_gear", _x];
	if (isPlayer _x) then { [] remoteExec ["TMF_acre2_fnc_clientInit", _x]; };
} forEach (allUnits select {side _x == blufor});
spo_overwatch_locations = [];

// Spawn garrison
private _garrisonUnits = round (spo_ai_initialManpower* random [0.4,0.45,0.5]);
([spo_centerPos, _garrisonUnits, spo_objective_radius] call spo_fnc_createGarrison) params ['_spawnedUnits', '_garrisonGrps'];
spo_garrison_groups = _garrisonGrps;
spo_garrison_units = _spawnedUnits;
// Garrisons stand still until players get close, so let the engine stop simulating them until then.
enableDynamicSimulationSystem true;
"Group" setDynamicSimulationDistance 1000;
{ _x enableDynamicSimulation true; } forEach spo_garrison_groups;
spo_ai_initialManpower = spo_ai_initialManpower - count _spawnedUnits;
spo_patrol_groups = [];

// Spawn guards	
private _directions = [0, 90, 180, 270];
[_directions, true] call CBA_fnc_shuffle;
{
	private _places = selectBestPlaces [(getMarkerPos spo_perimeter_mkrName) getPos [spo_objective_radius + (random 100), _x], 100, "(0 - waterDepth) * (5 + hills)", 1, 1];
	if (_places isEqualTo []) then { continue; };
	[(_places # 0) # 0] call spo_fnc_createGuardPoint;
} forEach _directions;

private _patrolPoints = [];
// patrol time
while {spo_ai_initialManpower > 0} do {
	private _numberOfMen = (random [4,5,6]) min (spo_ai_initialManpower);
    private _spawnPos = [];
    private _validPoses = selectBestPlaces [getMarkerPos spo_perimeter_mkrName, spo_perimeter_radius, "(0 - (waterDepth))", 1, 20];
    private _index = _validPoses findIf {
        private _pos = _x # 0;
        (_patrolPoints findIf {(_pos distance _x) <= 125}) == -1
    };
    // every candidate is already taken, reuse a random one rather than stacking on the first
    if (_index == -1) then { _index = floor random count _validPoses; };
    _spawnPos = (_validPoses # _index) # 0;
    _patrolPoints pushBack _spawnPos;
    [_numberOfMen, _spawnPos] call spo_fnc_createPatrol;
};
// Vehicles
if(spo_vehicleFaction != '') then {
	private _numberOfVehicles = round random [0, spo_vehiclePoints / 1.33, spo_vehiclePoints];
    spo_vehicleToSpawn = _numberOfVehicles;
	for "_i" from 1 to _numberOfVehicles do { 
		if(_i == 1) then {
			private _createdVeh = [spo_centerPos, 'combat'] call spo_fnc_createVehicle;
			if (isNull _createdVeh) then { continue; };
			[group (effectiveCommander _createdVeh), spo_centerPos, 1, 4, spo_objective_radius, true] call spo_fnc_patrol;
			spo_patrol_groups pushBack (group (effectiveCommander _createdVeh));
		} else {
			private _firstPos = selectRandom spo_reinforcement_locations;
			private _secondPos = selectRandom (spo_reinforcement_locations - [_firstPos]);
			if (isNil "_secondPos") then { _secondPos = spo_centerPos; };
			_firstPos = [_firstPos # 0, _firstPos # 1, 0];
			_secondPos = [_secondPos # 0, _secondPos # 1, 0];
			private _createdVeh = [_firstPos, 'combat'] call spo_fnc_createVehicle;
			if (isNull _createdVeh) then { continue; };
			private _wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp = [group (effectiveCommander _createdVeh), _secondPos, 0, "MOVE"] call CBA_fnc_addWaypoint;
			_wp setWaypointCompletionRadius 150;
			_wp setWaypointTimeout [3,6,8];
			_wp = [group (effectiveCommander _createdVeh), _firstPos, 0, "CYCLE"] call CBA_fnc_addWaypoint;
			_wp setWaypointCompletionRadius 150;
			_wp setWaypointTimeout [3,6,8];
			spo_patrol_groups pushBack (group (effectiveCommander _createdVeh));
		}
	};
};

spo_namespace = call CBA_fnc_createNamespace;
spo_alert_triggerd = 0;
spo_patrol_statemachine = [(missionConfigFile >> "SPO_PatrolStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
spo_garrison_statemachine = [(missionConfigFile >> "SPO_GarrisonStateMachine")] call CBA_statemachine_fnc_createFromConfig; 
spo_mission_statemachine = [(missionConfigFile >> "SPO_Missions" >> spo_missionClassName)] call CBA_statemachine_fnc_createFromConfig; 


private _enemyFactionMsg = format ["Enemy Faction: %1", getText (configFile >> "CfgLoadouts" >> spo_opforFaction >> "displayName")];
_enemyFactionMsg remoteExec ["systemChat"];
