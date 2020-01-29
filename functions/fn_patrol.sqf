params ["_grp", "_pos", ["_type",0, [0,1]],"_numberOfWaypoints", "_radius", "_tryOnRoad"];
if(count _pos == 2) then {
	_pos set [2, 0];
};
// CIRCLE
if(_type == 0) then {
	private _roads = [];
	private _index = 1;
	for "_angle" from 0 to 360 step (360/_numberOfWaypoints) do {
		private _point = _pos vectorAdd [_radius * (cos _angle) ,_radius * (sin _angle),0];
		private _empty = _point findEmptyPosition [0,50];
		if(count _empty > 0) then {_point = _empty};
		if(_tryOnRoad) then {
			private _road = [_point, 50,_roads] call BIS_fnc_nearestRoad;
			if(!isNull _road) then {
				_point = getpos _road;
				_roads pushBack _road;
			};
		};
		private _type = "Move";
		if(_index == _numberOfWaypoints+1) then {_type = "CYCLE"};
		private _wp = [_grp, _point, -1, _type] call CBA_fnc_addWaypoint;
		if(_index == 1) then {
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointFormation "STAG COLUMN";
			_wp setWaypointSpeed "LIMITED";
		};
		_index = _index +1;
	};
};
if(_type == 1) then {
	_onRoad = _tryOnRoad;
	private _quickFunc = {
		if(_onRoad) then {
			private _road = [_this, 50] call BIS_fnc_nearestRoad;
			if(!isNull _road) then {_this = getpos _road};
		};
		_this
	};
	private _topleft = (_pos vectorAdd [-(_radius/2),-(_radius/2),0])  call _quickFunc;

	private _topright = (_pos vectorAdd [-(_radius/2),(_radius/2),0])  call _quickFunc;

	private _bottomleft = (_pos vectorAdd [(_radius/2),-(_radius/2),0]) call _quickFunc;
	private _bottomright = (_pos vectorAdd [(_radius/2),(_radius/2),0]) call _quickFunc;

	private _type = "MOVE";
	private _wp = [_grp, _topleft, -1, _type] call CBA_fnc_addWaypoint;
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointFormation "STAG COLUMN";
	_wp setWaypointSpeed "LIMITED";

	private _wp = [_grp, _topright, -1, _type] call CBA_fnc_addWaypoint;
	private _wp = [_grp, _bottomright, -1, _type] call CBA_fnc_addWaypoint;
	private _wp = [_grp, _bottomleft, -1, _type] call CBA_fnc_addWaypoint;
	private _wp = [_grp, _bottomleft, -1, "CYCLE"] call CBA_fnc_addWaypoint;
};
if(_type == 2) then {
	private _roads = [];
	private _index = 1;
	for "_angle" from 360 to 0 step (-360/_numberOfWaypoints) do {
		private _point = _pos vectorAdd [_radius * (cos _angle) ,_radius * (sin _angle),0];
		private _empty = _point findEmptyPosition [0,50];
		if(count _empty > 0) then {_point = _empty};
		if(_tryOnRoad) then {
			private _road = [_point, 50,_roads] call BIS_fnc_nearestRoad;
			if(!isNull _road) then {
				_point = getpos _road;
				_roads pushBack _road;
			};
		};
		private _type = "Move";
		if(_index == _numberOfWaypoints+1) then {_type = "CYCLE"};
		private _wp = [_grp, _point, -1, _type] call CBA_fnc_addWaypoint;
		if(_index == 1) then {
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointFormation "STAG COLUMN";
			_wp setWaypointSpeed "LIMITED";
		};
		_index = _index +1;
	};
};