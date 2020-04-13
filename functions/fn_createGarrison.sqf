/// Garrison Buildings around the point
params ['_centerPos','_maxUnitsAllowed', '_radius'];
private _numOfBuildingPoses = 0;
private _buildings = [];
{ 
	private _bPosses = _x buildingPos -1; 
	if(count _bPosses > 0) then { 
	_buildings pushBack [_bPosses, _x]; 
	_numOfBuildingPoses = _numOfBuildingPoses + count _bPosses
	}; 
} forEach nearestObjects [_centerPos,["Fortress", "House","House_Small", "Ruins_F","BagBunker_base_F","Stall_base_F","Shelter_base_F"],_radius];
private _numberOfUnits = _maxUnitsAllowed min _numOfBuildingPoses;

[_buildings, true] call CBA_fnc_shuffle;

private _groups = [];
private _spawnedUnits = [];
while{_numberOfUnits > 0 && _numOfBuildingPoses > 0} do {
	private _index = _buildings call BIS_fnc_randomIndex;
	(_buildings # _index) params ["_poses", "_building"];
	private _grp = _building getVariable ['dsm_garrison_group', grpNull];

	// create group per building
	if(isNull _grp) then {
		_grp = createGroup [east, true];
		_building setVariable ['dsm_garrison_group', _grp];
		_grp setBehaviour "SAFE";
		_groups pushBack _grp;

		private _buildingCenter = _building modelToWorld (boundingCenter _building);
		private _buildingSize = (boundingBox _building) # 2;

		_grp setVariable ["dsm_garrisonData", [_buildingCenter, _buildingSize * 1.3, _buildingSize * 1.3, 0, false]];
	};

	private _posIndex = _poses call BIS_fnc_randomIndex;
	private _buildingPos = _poses # _posIndex;
	private _role = selectRandom spo_allowedRoles;
	private _solider = _grp createUnit ['O_Soldier_F',[0,0,0],[],0,'NONE'];

	_solider setPos _buildingPos;
	[_solider, _role] call dsm_fnc_gear;
	_solider disableAI 'PATH'; 
	_solider setUnitPos 'UP';

	_numberOfUnits = _numberOfUnits - 1;
	_spawnedUnits pushBack _solider;
	_numOfBuildingPoses = _numOfBuildingPoses - 1;
	_poses deleteAt _posIndex;
	if(count _poses <= 0) then {
		_buildings deleteAt _index;
	}
};
[_spawnedUnits, _groups]