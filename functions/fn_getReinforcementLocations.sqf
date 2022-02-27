params ["_centerPos", "_distance", "_headings"];

private _startRoad = objNull;
private _radius = spo_objective_radius/2;
private _vehicles = [];
// Todo add stop
while {isNull _startRoad && _radius <= spo_objective_radius} do {
	_radius = _radius + 50;
	_startRoad = [_centerPos, _radius] call TMF_common_fnc_getNearestRoad;
};

if(isNull _startRoad) then {
	private _pos = [_centerPos, 0, 500, 2, 0.25, 20, 0, [], [_centerPos,_centerPos]] call BIS_fnc_findSafePos;
	_startRoad = "Sign_Arrow_F" createVehicleLocal _pos;
};


private _onPathFinished = {
	params ['_agent', '_path'];

	private _path = (_path select {!(_x inArea spo_ao_mkrName)});
	if(_agent getVariable ["location", []] isEqualTo spo_centerPos && count _path >= 1 ) then {
		private _pos = _path # 0;
		private _road = [_pos, 50] call TMF_common_fnc_getNearestRoad;
		if(!isNull _road) then {
			_pos = getPos _road;
		};
		spo_reinforcement_locations pushBackUnique _pos;
	};
	deleteVehicle (objectParent _agent);
	deleteVehicle (_agent);
};


{
	private _pos = _centerPos getPos [_distance, _x];
	_pos = [_pos, 0, 250, 3, 0, 0.1, 0, [], [_pos,_pos]] call BIS_fnc_findSafePos;
	private _agent = createAgent ["B_Soldier_F", getpos _startRoad, [], 0, "NONE"];
	_agent setVariable ["location", _centerPos];
	private _car = "B_Quadbike_01_F" createVehicle getpos _startRoad;
	_vehicles pushBack _car;
	_agent moveInDriver _car;  
	_agent addEventHandler ["PathCalculated", _onPathFinished];
	_agent setDestination [_pos, "LEADER PLANNED", true];
} forEach _headings;
{
	deleteVehicle _x;
} forEach _vehicles;
publicVariable "spo_reinforcement_locations";