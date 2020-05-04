params ["_centerPos", "_radius"];
_numOfBuildingPoses = 0;
private _buildings = [];
{ 
    private _bPosses = _x buildingPos -1; 
    if(count _bPosses > 0) then { 
        _buildings pushBack [_bPosses, _x]; 
        _numOfBuildingPoses = _numOfBuildingPoses + count _bPosses
    }; 
} forEach nearestObjects [_centerPos,["Fortress", "House","House_Small", "Ruins_F","BagBunker_base_F","Stall_base_F","Shelter_base_F"],_radius];
[_buildings, _numOfBuildingPoses]