/// Garrison Buildings around the point
params ['_centerPos','_maxUnitsAllowed', '_radius'];
([_centerPos, _radius] call spo_fnc_nearBuildings) params ["_buildings", "_numOfBuildingPoses"];
private _numberOfUnits = _maxUnitsAllowed min _numOfBuildingPoses;

[_buildings, true] call CBA_fnc_shuffle;

private _groups = [];
private _spawnedUnits = [];
while{_numberOfUnits > 0 && _numOfBuildingPoses > 0} do {
	private _index = _buildings call BIS_fnc_randomIndex;
	(_buildings # _index) params ["_poses", "_building"];
	private _grp = _building getVariable ['spo_garrison_group', grpNull];

	// create group per building
	if(isNull _grp) then {
		_grp = createGroup [east, true];
		_building setVariable ['spo_garrison_group', _grp];
		_grp setBehaviour "SAFE";
		_groups pushBack _grp;

		private _buildingCenter = _building modelToWorld (boundingCenter _building);
		private _buildingSize = (boundingBox _building) # 2;

		_grp setVariable ["spo_garrisonData", [_buildingCenter, _buildingSize * 1.5, _buildingSize * 1.5, 0, false]];
	};
	private _numofPostions = (count _poses);
	private _unitsToSpawn = (random [1,_numofPostions/4, _numofPostions]) min _numberOfUnits;
	for "_i" from 1 to _unitsToSpawn do {
		private _posIndex = _poses call BIS_fnc_randomIndex;
		private _role = selectRandom spo_allowedRoles;

		private _buildingPos = _poses # _posIndex;
		private _solider = _grp createUnit ['O_Soldier_F',[0,0,0],[],0,'NONE'];

		_solider setPos _buildingPos;
		[_solider, _role] call spo_fnc_gear;
		_solider disableAI 'PATH'; 
		_solider setUnitPos 'UP';

		_numberOfUnits = _numberOfUnits - 1;
		_spawnedUnits pushBack _solider;
		_numOfBuildingPoses = _numOfBuildingPoses - 1;
		_poses deleteAt _posIndex;
	};
	
	if(count _poses <= 0) then {
		_buildings deleteAt _index;
	}
};
[_spawnedUnits, _groups]