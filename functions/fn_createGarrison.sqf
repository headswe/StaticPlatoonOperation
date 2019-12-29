/// Garrison Buildings around the point
params ['_centerPos','_amountOfUnits', '_radius'];
private _buildingPoses = [];
{ 
	_buildingPoses append (_x buildingPos -1)
} forEach nearestObjects [_centerPos,["Fortress", "House","House_Small", "Ruins_F","BagBunker_base_F","Stall_base_F","Shelter_base_F"],_radius];
private _buildingTangos = _amountOfUnits min (count _buildingPoses);

[_buildingPoses, true] call CBA_fnc_shuffle;

private _garrisonGrp = createGroup east;
_garrisonGrp setBehaviour "SAFE";

 for "_i" from 1 to _buildingTangos do {
	private _buildingPos = _buildingPoses deleteAt 0;
	private _role = selectRandom ['r','r','r','ftl','aar','ar','rat'];
	private _solider = _garrisonGrp createUnit ['O_Soldier_F',dsm_centerPos,[],0,'NONE'];

	_solider setPos _buildingPos;
	[_solider, _role] call dsm_fnc_gear;
	_solider disableAI 'PATH'; 
	_solider setUnitPos 'UP';
};

[_buildingTangos, _garrisonGrp];
