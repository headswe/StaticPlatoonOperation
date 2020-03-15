params ["_centerPos", "_distance", "_headings"];

private _startRoad = objNull;
private _radius = 3;
private _vehicles = [];
// Todo add stop
while {isNull _startRoad && _radius < 30} do {
	_radius = _radius + 10;
	_startRoad = [_centerPos, _radius] call TMF_common_fnc_getNearestRoad;
};

if(isNull _startRoad) then {
	private _pos = [_centerPos, 0, 500, 1.5, 0, 20, 0, [], [_centerPos,_centerPos]] call BIS_fnc_findSafePos;
	_startRoad = "Sign_Arrow_F" createVehicleLocal _pos;
};

dsm_reinforcement_locations = [];
private _onPathFinished = {
	params ['_agent', '_path'];
	systemChat format["%1", _path];
	private _pos = (_path # (count _path - 1));
	dsm_reinforcement_locations pushBackUnique _pos;
	deleteVehicle (objectParent _agent);
	deleteVehicle (_agent);
};


{
	private _pos = _centerPos getPos [_distance, _x];
	_pos = [_pos, 0, 500, 1.5, 0, 20, 0, [], [_pos,_pos]] call BIS_fnc_findSafePos;
	private _agent = createAgent ["B_Soldier_F", getpos _startRoad, [], 0, "NONE"];
	private _car = "B_Quadbike_01_F" createVehicle getpos _startRoad;
	_vehicles pushBack _car;
	_agent moveInDriver _car;  
	_agent addEventHandler ["PathCalculated",_onPathFinished];
	_agent setDestination [_pos, "LEADER PLANNED", true];
} forEach _headings;
{
	deleteVehicle _x;
} forEach _vehicles;
publicVariable "dsm_reinforcement_locations";