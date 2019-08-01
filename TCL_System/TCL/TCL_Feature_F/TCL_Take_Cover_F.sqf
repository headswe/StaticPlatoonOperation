#include "TCL_Macros.hpp"

TCL_Take_Cover_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_units"];
	
	private _array = ( (TCL_Sneaking select 0) + (TCL_Garrison select 0) );
	
	if (_group in _array) exitWith {};
	
	private _bool = False;
	
	_array = (TCL_Hold select 0);
	
	if (_group in _array) then
	{
		_bool = True;
	};
	
	_array = ( (TCL_Heal select 0) + (TCL_Rearm select 0) + (TCL_Take_Cover select 0) + (TCL_House_Search select 0) + (TCL_Static_Weapon select 0) );
	
	_units = _units - _array;
	
	private ["_unit","_enemy"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (floor (random 100) < (TCL_Feature select 16) ) then
		{
			if ( (alive _unit) && { (isNull objectParent _unit) } ) then
			{
				[_unit, _enemy, _group, _bool] call (TCL_Take_Cover_F select 1);
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_enemy","_group","_bool"];
	
	if (alive _enemy) then
	{
		private _array = (_unit getVariable "TCL_Take_Cover");
		
		if (isNil "_array") then
		{
			_unit setVariable ["TCL_Take_Cover", [time, [], (getPos _unit) ] ];
			
			_array = (_unit getVariable "TCL_Take_Cover");
			
			private _text = format ["TCL_Take_Cover_F > Error > %1 > %2 > %3 > %4", _unit, (side _unit), _group, (typeOf _unit) ];
			
			diag_log ("////////////////////////////////// TCL error dump //////////////////////////////////" + endl + _text + endl + "///////////////////////////////////////////////////////////////////////////");
			
			player sideChat _text;
			
			_string = format ["%1<t align='center'>Ups...!<br/>Something went wrong %2...<br/>Don't worry the problem will be solved as soon as this message appears.<br/>Please help me fix this issue by reporting the line stored in your .rpt file!</t>", (TCL_Text_F select 5), name player];
			
			hint parseText _string;
		};
		
		if (time > (_array select 0) ) then
		{
			private _time = (time + 15);
			
			if (_unit knowsAbout vehicle _enemy > 0) then
			{
				// _time = _time + (random 15);
				
				_time = _time + (random 30);
				
				private _object = [_unit, _enemy, _group, _bool, _array] call (TCL_Take_Cover_F select 2);
				
				if (alive _object) then
				{
					(TCL_Take_Cover select 0) pushBack _unit;
					
					(TCL_Take_Cover select 1) pushBack _object;
					
					[_unit, _enemy, _group, _object, _bool] spawn (TCL_Take_Cover_F select 3);
					
					// player sideChat format ["TCL_Take_Cover_F > %1 > %2", _unit, (typeOf _object) ];
				};
			};
			
			_array set [0, _time];
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_enemy","_group","_bool","_array"];
	
	private _return = objNull;
	
	if (alive _unit) then
	{
		private _position = _unit;
		
		private _distance = (TCL_Feature select 17);
		
		private _waypoint = (_group getVariable "TCL_Waypoint");
		
		if (_unit distance _waypoint < _distance) then
		{
			_position = _waypoint;
		};
		
		if (_group in (TCL_Flanking select 0) ) then
		{
			_position = [_unit, _group, _enemy, _position, _distance] call (TCL_Flanking_F select 1);
		};
		
		// private _objects = [];
		
		// private _objects = [_unit, _array, _distance] call TCL_Cover_F;
		
		private _objects = (_array select 1);
		
		if ( (_objects isEqualTo [] ) || (_unit distance (_array select 2) > _distance) ) then
		{
			// _objects = nearestTerrainObjects [_position, ["TREE","WALL","HOUSE"], _distance];
			
			// _objects = nearestTerrainObjects [_position, ["HIDE","ROCK","ROCKS","BUSH"], _distance];
			
			// _objects = nearestTerrainObjects [_position, ["TREE","WALL","HOUSE","FENCE"], _distance];
			
			// _objects = nearestTerrainObjects [_position, ["HIDE","BUSH","TREE","WALL","HOUSE","FENCE"], _distance];
			
			// _objects = nearestTerrainObjects [_position, ["ROCK","ROCKS","HIDE","BUSH","TREE","HOUSE"], _distance];
			
			_objects = nearestTerrainObjects [_position, ["ROCK","ROCKS","HIDE","BUSH","TREE","WALL","HOUSE","FENCE"], _distance];
			
			_array set [1, _objects];
			
			_array set [2, (getPos _unit) ];
			
			// player sideChat format ["TCL_Take_Cover_F > Objects > %1 > %2", _unit, (count _objects) ];
		};
		
		_objects = _objects - (TCL_Take_Cover select 1);
		
		if (_objects isEqualTo [] ) exitWith {};
		
		private "_object";
		
		private _count = 0;
		
		for "_count" from _count to (count _objects - 1) do
		{
			_object = (_objects select _count);
			
			if ( (_bool) || (_unit distance _waypoint < _distance) || ( (_unit distance _enemy) > (_enemy distance _object) ) ) then
			{
				// if ( ( (_unit distance _object) < (_enemy distance _object) ) && { (_enemy distance _object > 5) } ) then
				
				// if ( ( (_unit distance _object) < (_enemy distance _object) ) || (_unit distance _object > 5) || (_enemy distance _object > 5) ) then
				
				if ( ( (_unit distance _object) < (_enemy distance _object) ) && { (_enemy distance _object > _distance) } ) then
				{
					// player sideChat format ["TCL_Take_Cover_F > Object > %1", _object];
					
					// if ( (boundingBox _object select 1) findIf { ( (_x < 0.7) || (_x > 7) ) } > -1) exitWith
					
					if ( (boundingBox _object select 1) findIf { (_x > 15) } > -1) exitWith
					{
						// player sideChat format ["TCL_Take_Cover_F > BoundingBox > %1", _object];
					};
					
					if ( (TCL_Take_Cover select 1) findIf { (_object distance _x < 3) } > -1) exitWith
					{
						// player sideChat format ["TCL_Take_Cover_F > Distance > %1", _object];
					};
					
					if (_bool) exitWith
					{
						if ( [_group, _object] call TCL_Trigger_F) then
						{
							_return = _object;
						};
					};
					
					_return = _object;
				};
			};
			
			if (alive _return) exitWith
			{
				// player sideChat format ["TCL_Take_Cover_F > Exit > %1 > %2 > %3", _unit, _count, (count _objects) ];
			};
		};
		
		if (alive _return) then
		{
			_return;
		}
		else
		{
			// _return = (_objects select 0);
			
			// player sideChat format ["TCL_Take_Cover_F > Behind > %1 > %2", _unit, _object];
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Take Cover
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_enemy","_group","_object","_bool"];
	
	// player sideChat format ["TCL_Take_Cover_F > %1 > %2 > %3 > %4", _object, (typeOf _object), (sizeOf typeOf _object), (boundingBox _object select 1) ];
	
	private _random = 50;
	
	if (_unit distance _object > 10) then
	{
		_random = 75;
	};
	
	if (floor (random 100) < _random) then
	{
		_unit setUnitPos "UP";
	}
	else
	{
		_unit setUnitPos "MIDDLE";
	};
	
	private ["_marker","_text"];
	
	if (TCL_Debug select 3) then
	{
		_marker = [ [_unit, time], (getPos _object), "Icon", [1,1], "mil_triangle", "colorWhite"] call TCL_Create_Marker_F;
		
		_text = {private _string = "Take Cover"; if (_unit in (TCL_Flanking select 1) ) then {_string = "Flanking"} else {if (_unit in (TCL_Flanking select 2) ) then {_string = "Flanking"} }; format ["%1 ( %2 ) %3 %4", _unit, _string, (_unit distance _object), _object] };
		
		_marker setMarkerText call _text;
	};
	
	private _direction = (_object getDir _enemy);
	
	private _boundingBox = (boundingBox _object select 1 select 0);
	
	// player sideChat format ["TCL_Take_Cover_F > BoundingBox > %1 > %2 > %3", _unit, _object, (boundingBox _object select 1) ];
	
	if (_boundingBox > 3) then
	{
		_boundingBox = 3;
	}
	else
	{
		if (_boundingBox < 1) then
		{
			_boundingBox = _boundingBox + 1;
		};
	};
	
	private _cover = [_object, - _boundingBox, _direction] call TCL_Real_Pos_F;
	
	_unit doMove _cover;
	
	private _spot = objNull;
	
	if (TCL_Debug select 6) then
	{
		_spot = createVehicle ["Sign_Arrow_Large_Blue_F", _cover, [], 0, "CAN_COLLIDE"];
	};
	
	private _time = (time + 10);
	
	_time = _time + (_unit distance _cover);
	
	while { ( (alive _unit) && { (time < _time) } ) } do
	{
		// if (_unit distance _cover < 5) then {_unit setUnitPos "MIDDLE"};
		
		// if ( (unitReady _unit) || (_unit distance _cover < 1) ) exitWith
		
		// if (_unit distance _cover < _boundingBox) exitWith
		
		// if (_unit distance2D _cover < 1) exitWith
		
		// if ( (unitReady _unit) && { (_unit distance _cover < _boundingBox) } ) exitWith
		
		// player sideChat format ["TCL_Take_Cover_F > %1 > %2 > %3", _unit, (unitReady _unit), (_unit distance _cover) ];
		
		if (_unit distance2D _cover < _boundingBox) exitWith
		{
			// player sideChat format ["TCL_Take_Cover_F > %1 > %2 > %3", _unit, (_unit distance _cover), (boundingBox _object select 1 select 2) ];
			
			// player sideChat format ["TCL_Take_Cover_F > BoundingBox > %1 > %2 > %3 > %4", _unit, _cover, _object, (boundingBox _object select 1) ];
		};
		
		if (TCL_Debug select 3) then
		{
			_marker setMarkerText call _text;
		};
		
		sleep 1;
	};
	
	if (TCL_Debug select 3) then
	{
		deleteMarker _marker;
	};
	
	if (alive _spot) then
	{
		deleteVehicle _spot;
	};
	
	if (alive _unit) then
	{
		private _flanking = True;
		
		if (time < _time) then
		{
			if (TCL_Debug select 6) then
			{
				_spot = createVehicle ["Sign_Arrow_Large_Green_F", _cover, [], 0, "CAN_COLLIDE"];
			};
			
			_unit setUnitPos "AUTO";
			
			// _unit doWatch (getPos _enemy);
			
			if (_object isKindOf "House") exitWith
			{
				sleep 10 + (random 30);
				
				// player sideChat format ["TCL_Take_Cover_F > House > %1", _unit, _object];
			};
			
			_unit forceSpeed 0;
			
			if ( (floor (random 100) < 50) && { (_unit distance _enemy < 300) } ) then
			{
				sleep 10 + (random 30);
				
				if (combatMode _group isEqualTo "YELLOW") then
				{
					// sleep 10 + (random 30);
				};
				
				if (alive _unit) then
				{
					if (_bool) then
					{
						// sleep 10 + (random 30);
					};
					
					_group = (group _unit);
					
					private _waypoint = (_group getVariable "TCL_Waypoint");
					
					if (_unit distance _waypoint < 100) then
					{
						if (alive _spot) then
						{
							deleteVehicle _spot;
							
							_spot = createVehicle ["Sign_Arrow_Large_F", _cover, [], 0, "CAN_COLLIDE"];
						};
						
						sleep 10 + (random 30);
					};
				};
			}
			else
			{
				sleep 10 + (random 30);
			};
			
			_random = (TCL_Feature select 18);
			
			if (_group in (TCL_Flanking select 0) ) then
			{
				_random = 100;
			};
			
			if (floor (random 100) < _random) then
			{
				_array = ( (TCL_Flanking select 1) + (TCL_Flanking select 2) );
				
				// if (_unit in _array) then
				// {
				
				_time = (time + 10);
				
				_random = (random 30);
				
				_time = (_time + _random);
				
				TCL_DeleteAT(TCL_Take_Cover,0,_unit);
				
				if (alive _spot) then
				{
					deleteVehicle _spot;
					
					_spot = createVehicle ["Sign_Arrow_Large_Yellow_F", _cover, [], 0, "CAN_COLLIDE"];
				};
				
				while { (alive _unit) } do
				{
					if ( (time > _time) || (_unit in (TCL_Take_Cover select 0) ) ) exitWith
					{
						_flanking = False;
					};
					
					sleep 1;
				};
				
				// };
			};
			
			_unit forceSpeed -1;
			
			if (alive _spot) then
			{
				deleteVehicle _spot;
			};
		};
		
		_unit setUnitPos "AUTO";
		
		if (_flanking) then
		{
			TCL_DeleteAT(TCL_Take_Cover,0,_unit);
		};
		
		sleep 10 + (random 30);
		
		TCL_DeleteAT(TCL_Take_Cover,1,_object);
	}
	else
	{
		TCL_DeleteAT(TCL_Take_Cover,0,_unit);
		
		TCL_DeleteAT(TCL_Take_Cover,1,_object);
	};
	
	}
];