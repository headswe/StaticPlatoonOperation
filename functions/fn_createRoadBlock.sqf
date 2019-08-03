private _debug = false;
private _pos = dsm_centerPos;
private _radius = dsm_perimeter_radius;
private _roads = (_pos nearRoads _radius);
_roads = _roads apply { [_x distance _pos, _x] };;
// get the farthers away road piece
_roads sort false;
_cloestRoad = (_roads # (count _roads - 1)) # 1;
_farRoad = selectRandom ((_roads select [0, (count _roads)]) select {(_x # 1) distance2d _cloestRoad > 100}) #1;
/*
deleteMarker "far";
deleteMarker "close";
_mkr = createMarker ["far",getpos _farRoad];
_mkr setMarkerSize [1,1];
_mkr setMarkerType "mil_dot";
_mkr setMarkerColor "ColorRed";
_mkr = createMarker ["close",getpos _cloestRoad];
_mkr setMarkerSize [1,1];
_mkr setMarkerType "mil_dot";
_mkr setMarkerColor "ColorRed";
*/
dsm_spawnBuilding = {
	params["_path","_pos","_dir"];
	_createdObjects = [];
	_objects = "isArray (_x >> 'position')" configClasses _path;
	_multiplyMatrixFunc = {
		private ["_array1", "_array2", "_result"];
		_array1 = _this select 0;
		_array2 = _this select 1;

		_result =
		[
			(((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),
			(((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))
		];

		_result
	};
	{
		if(!isArray (_x >> "position")) then {systemChat "wat fuck"};
		_objpos = getArray(_x >> "position");
		_rotMatrix =
		[
			[cos _dir, sin _dir],
			[-(sin _dir), cos _dir]
		];
		_objpos = [_rotMatrix, _objpos] call _multiplyMatrixFunc;
		_objpos set [2,0];

		_objpos = _pos vectoradd _objpos;

		_odir = getNumber(_x >> "dir");
		_classname = getText(_x >> "vehicle");
		_veh = _classname createVehicle _objpos;
		_veh setdir (_dir+_odir);
		_veh setpos _objpos;
		_veh = [_veh] call BIS_fnc_replaceWithSimpleObject;
		_createdObjects pushBack _veh;
	} forEach _objects;

	_createdObjects;
};
_onPathFinished = {
	params ['_agent', '_path'];
	path = _path apply {[_x # 0, _x  # 1, 0]};
	private _inside = (_path inAreaArray "assaultObjectivePerimeter") select {isOnRoad _x} apply {[_x distance dsm_centerPos, _x]};
	_inside sort false;
	/*
	{
		deleteMarker ("marker" + str _forEachIndex);
		_mkr = createMarker ["marker" + str _forEachIndex,_x];
		_mkr setMarkerSize [1,1];
		_mkr setMarkerType "mil_dot";
		_mkr setMarkerColor "ColorYellow";
	} foreach _inside;*/
	private _pos = (_inside # (count _inside - 1)) # 1;
	private _road = roadAt _pos;
	_roadBlockClass = selectRandom [
		(configfile >> "CfgGroups" >> "Empty" >> "Ares_MilitaryStructures" >> "Ares_MilitaryStructures_RoadCheckpoints" >> "Ares_MilitaryStructures_RoadCheckpoints_3"),
		(configfile >> "CfgGroups" >> "Empty" >> "Ares_MilitaryStructures" >> "Ares_MilitaryStructures_RoadCheckpoints" >> "Ares_MilitaryStructures_RoadCheckpoints_0")
	];
	_dir = (_road getDir ((roadsConnectedTo _road) # 0));
	if(isNil "_dir" || _dir isEqualType 0) then {
		_dir = getDir _road;
	};
	_script = [_roadBlockClass, getpos _road,_dir] spawn dsm_spawnBuilding;
	_onFinished = {
		private _grp = createGroup east;
		private _spawnPos = _this # 1;
		for "_i" from 1 to 4 do {
			private _role = selectRandom ['r','r','r','ftl','aar','ar','rat'];
			private _solider = _grp createUnit ['O_Soldier_F',[0,0,0],[],0,'NONE'];
			[_solider, _role] call dsm_fnc_gear;
		};
	//	[_grp, _spawnPos, 25, "GUARD", "AWARE", "YELLOW", "FULL", "STAG COLUMN"] call CBA_fnc_addWaypoint;
		[_grp, _spawnPos,15] call CBA_fnc_taskDefend;
	};
	[{scriptDone (_this # 0)}, _onFinished ,[_script, _pos]] call CBA_fnc_waitUntilAndExecute;
};
isNil { calculatePath ["wheeled_APC","careless",getpos _cloestRoad,getpos _farRoad] addEventHandler ["PathCalculated", _onPathFinished] }; 