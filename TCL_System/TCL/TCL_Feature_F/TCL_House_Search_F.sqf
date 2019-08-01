#include "TCL_Macros.hpp"

TCL_House_Search_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// House Search Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// House Search
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _units = (units _group);
	
	private _array = ( (TCL_House_Search select 0) + (TCL_Static_Weapon select 0) );
	
	_units = _units - _array;
	
	private _leader = (leader _group);
	
	_units deleteAt (_units find _leader);
	
	_units = _units select { ( (alive _x) && { (isNull objectParent _x) } ) };
	
	if (count _units > 1) then
	{
		private _unit = _units select (count _units - 1);
		
		private _objects = nearestObjects [_logic, ["House"], 100];
		
		_objects = _objects - (TCL_House_Search select 1);
		
		if (_objects isEqualTo [] ) exitWith {};
		
		private _object = (_objects select 0);
		
		if (_unit distance _object < 100) then
		{
			[_unit, _group, _logic, _objects] call (TCL_House_Search_F select 1);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// House Search Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// House Search
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_logic","_objects"];
	
	private ["_building","_positions"];
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_building = (_objects select _count);
		
		_positions = [_building] call TCL_Building_Pos_F;
		
		// player sideChat format ["TCL_House_Search_F > Positions > %1", _positions];
		
		if (_positions > 1) exitWith
		{
			[_unit, _group, _logic, _building, _positions] spawn (TCL_House_Search_F select 2);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// House Search Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// House Search
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_logic","_building","_positions"];
	
	(TCL_House_Search select 0) pushBack _unit;
	
	(TCL_House_Search select 1) pushBack _building;
	
	if (alive _unit) then
	{
		private ["_position","_distance","_time"];
		
		while { ( (alive _unit) && { (alive _logic) } && { (_positions > 0) } && { (_unit distance _building < 100) } ) } do
		{
			// player sideChat format ["TCL_House_Search_F > Positions > %1", _positions];
			
			_position = (_building buildingPos _positions);
			
			_distance = (_unit distance _position);
			
			if (_distance > 3) then
			{
				_unit doMove _position;
				
				_time = (time + 10);
				
				_time = (_time + _distance);
				
				while { ( (alive _unit) && { (alive _logic) } && { (time < _time) } && { (_unit distance _building < 100) } ) } do
				{
					if (unitReady _unit) exitWith
					{
						// doStop _unit;
						
						sleep (random 5);
						
						// player sideChat format ["TCL_House_Search_F > Unit > %1", _unit];
					};
					
					if (_unit distance _logic > 100) exitWith
					{
						_positions = 0;
						
						// player sideChat format ["TCL_House_Search_F > Distance > %1", _unit];
					};
					
					sleep 5;
				};
			};
			
			_positions = _positions - 1;
		};
		
		// private _leader = (leader _group);
		
		// _unit doMove (getPos _leader);
		
		// _unit doFollow _leader;
	};
	
	TCL_DeleteAT(TCL_House_Search,0,_unit);
	
	[_unit, _group] call (TCL_Follow_F select 0);
	
	if (False) then
	{
		[_unit, _group, _logic, _building] spawn (TCL_House_Search_F select 3);
	};
	
	sleep 30 + (random 50);
	
	if (alive _unit) then
	{
		TCL_DeleteAT(TCL_House_Search,1,_building);
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// House Search Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// House Search
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_logic","_building"];
	
	private _bool = True;
	
	private _time = (time + 30);
	
	private _position = (getPos _unit);
	
	private _boundingBox = (boundingBox _building);
	
	private _value = (_boundingBox select 1 select 0);
	
	if (_value < (_boundingBox select 1 select 1) ) then
	{
		_value = (_boundingBox select 1 select 1);
	};
	
	_value = (_value / 2);
	
	while { ( (alive _unit) && { (_bool) } ) } do
	{
		if (time > _time) then
		{
			if (_unit distance _building > _value) then
			{
				_bool = False;
			}
			else
			{
				_unit setDamage 1;
			};
		};
		
		sleep 5;
	};
	
	}
];