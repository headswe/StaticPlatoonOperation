private _playerCount = (count (playableUnits + switchableUnits)) max 1;
dsm_aiRatioCount =  round ((5 + (_playerCount * dsm_aiRatio) ) min 180);

{
	[_x] remoteExec ["dsm_fnc_gear", _x];
	[] remoteExec ["TMF_acre2_fnc_clientInit", _x];
} foreach (allUnits select {side _x == blufor});


// Spawn garrison
_garrisonUnits = round (dsm_aiRatioCount*selectRandom [0.3,0.35,0.4]);
([dsm_centerPos, _garrisonUnits, dsm_objective_radius*(selectRandom [1,1.1,1.2,1.3])] call dsm_fnc_createGarrison) params ['_spawnedUnits', '_garrisonGrps'];
dsm_garrison_groups = _garrisonGrps;
dsm_garrison_units = _spawnedUnits;
dsm_aiRatioCount = dsm_aiRatioCount - count _spawnedUnits;
dsm_guard_groups = [];
dsm_patrol_groups = [];

// Spawn guards	
_directions = [random 90, random 90 + 90, random 90 + 180, random 90 + 270];
[_directions, true] call CBA_fnc_shuffle;

{
	_spawnPos = dsm_centerPos getPos [(random dsm_perimeter_radius max dsm_objective_radius), _x];
	[_spawnPos] call dsm_fnc_createGuardPoint;
} foreach _directions;

// patrol time
while {dsm_aiRatioCount > 0} do {
	private _numberOfMen = dsm_aiRatioCount;
	if (dsm_aiRatioCount > 6) then { _numberOfMen = round(2 + random 6);};
	_patrolDir = random 360;
	private _spawnPos = dsm_centerPos getpos [(dsm_objective_radius+(random dsm_perimeter_radius)) min dsm_perimeter_radius , _patrolDir];
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
		}
	};
};

AI_SPAWNED = true;


dsm_alert_triggerd = 0;
[{
	_blueforUnits = allUnits select {side _x == blufor};
	// garrison spotting
	{
		private _grp = _x;
		private _playersKnown =  _blueforUnits select { _grp knowsAbout _x >= 2};
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
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 200;
				_wp = _x addWaypoint [getpos (selectRandom _playersKnown), -1];
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 200;
			} foreach dsm_patrol_groups;
		}; 
	} foreach dsm_garrison_groups;

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
			//	[getpos leader _x] call dsm_fnc_createFlare;
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
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 200;
				_wp = _squad addWaypoint [getpos leader _patrolGrp, -1];
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 200;
				systemChat "reinforcement sent";
				_squad setVariable ["dsm_reinforceing", _patrolGrp];
				
			}
		}
	} foreach dsm_patrol_groups;

	{
		private _data = _x getVariable ["dsm_garrisonData", []];
		if(count _data >= 1) then {
			private _num = {(getPos _x) inArea _data} count _blueforUnits;
			if(_num > 0) then {
				{
					_x enableAI "PATH";
					_x setUnitPos "AUTO";
				} forEach units _x;

				private _wp = _x addWaypoint [getPos (leader _x), -1];
				_wp setWaypointType "MOVE";
				_wp setWaypointCompletionRadius 300;
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 300;
				_x setVariable ["dsm_triggered", true];
			}
		};
	} foreach (dsm_garrison_groups select {!(_x getVariable ["dsm_triggered", false])});
}, 5] call CBA_fnc_addPerFrameHandler