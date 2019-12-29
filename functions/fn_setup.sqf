private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if(!isMultiplayer) then {
	_playerCount = 6;
};
dsm_aiRatioCount =  round ((5 + (_playerCount * dsm_aiRatio) ) min 120);

{
	[_x] remoteExec ["dsm_fnc_gear", _x];
} foreach (allUnits select {side _x == blufor});


// Spawn garrison
_garrisonUnits = round (dsm_aiRatioCount*selectRandom [0.3,0.35,0.4]);
([dsm_centerPos, _garrisonUnits, dsm_objective_radius] call dsm_fnc_createGarrison) params ['_unitsCreated', '_garrisonGrp'];
dsm_garrison_group = _garrisonGrp;
dsm_aiRatioCount = dsm_aiRatioCount - _unitsCreated;
// configfile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps"

// Spawn guards
_directions = [random 90, random 90 + 90, random 90 + 180, random 90 + 270];
[_directions, true] call CBA_fnc_shuffle;
dsm_guard_groups = [];

{
	_spawnPos = dsm_centerPos getPos [(random dsm_perimeter_radius max dsm_objective_radius), _x];
	_spawnPos = _spawnPos findEmptyPosition [0, 30, "B_Quadbike_01_F"];
	"Campfire_burning_F" createVehicle _spawnPos;
	private _grp = [_spawnPos, 2] call dsm_fnc_createSquad;
	_grp setBehaviour "SAFE";
	_grp allowFleeing 0;
	dsm_guard_groups pushBack _grp;

} foreach _directions;

dsm_patrol_groups = [];
_patrolDir = random 360;
while {dsm_aiRatioCount > 0} do {
	private _thisPatrolNumbers = dsm_aiRatioCount;
	if (dsm_aiRatioCount > 6) then { _thisPatrolNumbers = round(2 + random 4);};

	private _spawnPos = dsm_centerPos getpos [(dsm_objective_radius+(random dsm_perimeter_radius)) min dsm_perimeter_radius , _patrolDir];
	private _grp = [_spawnPos, _thisPatrolNumbers] call dsm_fnc_createSquad;
	_grp setCombatMode "RED";
	_grp allowFleeing 0;
	_patrolDir = _patrolDir + random 180;


	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "STAG COLUMN";
	_wp setWaypointTimeout [3,6,9];
	_wp setWaypointCompletionRadius 100;

	_otherpos = dsm_centerPos getpos [(dsm_objective_radius+(random dsm_perimeter_radius)) min dsm_perimeter_radius, _patrolDir+180];
	_wp = _grp addWaypoint [_otherpos, 0];
	_wp setWaypointTimeout [3,6,9];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 100;

	_wp = _grp addWaypoint [_spawnPos, 0];
	_wp setWaypointType "CYCLE";


	{_x setPos _spawnPos} forEach units _grp;
	// Create waypoint patrol
	dsm_patrol_groups pushBack _grp;
	dsm_aiRatioCount = dsm_aiRatioCount - _thisPatrolNumbers;
};
if(dsm_vehicleFaction != '') then {
	private _vehicles = ((dsm_factions getVariable [dsm_vehicleFaction, []]) # 2) apply {[getArray ((_x) >> "threat")#0, _x]};
	_vehicles = _vehicles select {
		_x#0 >= 0.31 && !((_x#1 >> "isUav") call BIS_fnc_getCfgDataBool) 
		&& ((configName (_x#1)) isKindOf "LandVehicle") 
		&& !((configName (_x#1)) isKindOf "man");
		};
	_vehicleConfig = (selectRandom _vehicles #1);
	_pos = [dsm_centerPos, 0, 200, 2, 0, 20, 0, [], [dsm_centerPos,dsm_centerPos]] call BIS_fnc_findSafePos;
	private _grp = createGroup east;
	private _veh = createVehicle [configName _vehicleConfig, _pos, [], 0,'FLY'];
	private _crewCount = {round getNumber (_x >> "dontCreateAI") < 1 && 
                      ((_x == _vehicleConfig && {round getNumber (_x >> "hasDriver") > 0}) ||
                       (_x != _vehicleConfig && {round getNumber (_x >> "hasGunner") > 0}))} count ([configName _vehicleConfig, configNull] call BIS_fnc_getTurrets);
	private _grp = [[0,0,0], _crewCount] call dsm_fnc_createSquad;
	{_x moveInAny _veh} forEach units _grp;
};

AI_SPAWNED = true;


dsm_alert_triggerd = 0;
[{
	// garrison spotting
	private _playersKnown =  ((playableUnits + switchableUnits)) select {dsm_garrison_group knowsAbout _x >= 2};
	if((count _playersKnown > 0 && (time - dsm_alert_triggerd) >= 30)) then {
		 dsm_alert_triggerd = time;
		 {
			[_x] call CBA_fnc_clearWaypoints;
			private _wp = _x addWaypoint [getpos leader _x, -1];
			_wp = _x addWaypoint [getpos leader _x, -1];
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointSpeed "FULL";
			_wp setWaypointPosition (getpos leader _x);
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 100;
			_wp = _x addWaypoint [getpos (selectRandom _playersKnown), -1];
			_wp setWaypointType "SAD";
			_wp setWaypointCompletionRadius 100;
		 } foreach dsm_patrol_groups;
	};

	private _reinforcement_groups = (dsm_patrol_groups + dsm_guard_groups) select {({alive _x} count (units _x)) > 0};
	{
		_patrolGrp = _x;
		_targets = (leader _patrolGrp nearTargets 400) select {_x # 2 == west};
		_reinforceing = _patrolGrp getVariable ["dsm_reinforceing",grpNull];
		if(isNull _reinforceing && {count _targets > 0} && {behaviour (leader _patrolGrp) == 'COMBAT'} &&
		 {time - (_patrolGrp getVariable ["dsm_reinforcement_called", 0]) >= 10}) then {
			private _squads = _reinforcement_groups select {_x != _patrolGrp} apply {[leader _x distance leader _patrolGrp, _x]};
			private _squad = grpNull;
			while {count _squads > 0 && isNull _squad} do {
				private _s = (_squads deleteAt 0) # 1;
				private _sTargets = (leader _s nearTargets 400) select {_x # 2 == west};
				if(count _sTargets <= 0 && isNull (_s getVariable ["dsm_reinforceing",grpNull])) then {
					_squad = _s;
				}
			};
			if(!isNull _squad) then {
				[getpos leader _x] call dsm_fnc_createFlare;
				_patrolGrp setVariable ["dsm_reinforcement_called", time];
				{_squad reveal [_x # 4, (_patrolGrp knowsAbout _x # 4)]} forEach _targets;
				[_squad] call CBA_fnc_clearWaypoints;
				private _wp = _squad addWaypoint [getpos leader _squad, -1];
				private _wp = _squad addWaypoint [getpos leader _squad, -1];
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointSpeed "FULL";
				_wp setWaypointCompletionRadius 100;
				_wp setWaypointPosition (getpos leader _squad);
				_wp setWaypointType "MOVE";
				_squad setCurrentWaypoint _wp;
				_wp = _squad addWaypoint [getpos leader _patrolGrp, -1];
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 100;
				systemChat "reinforcement sent";
				_squad setVariable ["dsm_reinforceing", _patrolGrp];
				
			}
		}

	} foreach _reinforcement_groups


}, 10] call CBA_fnc_addPerFrameHandler