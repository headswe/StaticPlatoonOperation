params ["_centerPos", "_distance", "_headings"];

private _startRoad = objNull;
private _radius = 0;

// Todo add stop
while {isNull _startRoad} do {
	_radius = _radius + 100;
	_startRoad = [_centerPos, _radius] call TMF_common_fnc_getNearestRoad;
};

dsm_reinforcement_locations = [];
private _onPathFinished = {
	params ['_agent', '_path'];
	private _pos = (_path # (count _path - 1));
	private _road = objNull;
	private _radius = 0;
	while {isNull _road} do {
		_radius = _radius + 100;
		_road = [_pos, _radius] call TMF_common_fnc_getNearestRoad;
	};
	dsm_reinforcement_locations pushBackUnique _road;
};


_agent = objNull;
{
	private _pos = _centerPos getPos [_distance, _x];
	private _road = objNull;
	private _radius = 0;
	while {isNull _road} do {
		_radius = _radius + 100;
		_road = [_pos, _radius] call TMF_common_fnc_getNearestRoad;
	};
	private _agt = calculatePath ["wheeled_APC","careless",getpos _startRoad,getpos _road];
	_agt addEventHandler ["PathCalculated", _onPathFinished];
} forEach _headings;
publicVariable "dsm_reinforcement_locations";