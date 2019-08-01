#include "TCL_Macros.hpp"

TCL_Garrison_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Garrison Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _time = 5 - (random 3);
	
	if (_group in (TCL_Garrison select 0) ) then
	{
		_time = 0;
	};
	
	sleep _time;
	
	private _units = (units _group);
	
	if (_group in (TCL_Freeze select 0) ) exitWith {};
	
	if (_units findIf { (alive _x) } > -1) then
	{
	
	if (TCL_Feature select 2) then
	{
		private _leader = (leader _group);
		
		if (isNull objectParent _leader) then
		{
			if (count (waypoints _group) == 1) then
			{
				if (_group in (TCL_Reinforcement select 0) ) exitWith {};
				
				private _array = [_group] call (TCL_Garrison_F select 1);
				
				if (_array isEqualTo [] ) exitWith {};
				
				private _building = (_array select 0);
				
				private _bool = True;
				
				if (_group in (TCL_Hold select 0) ) then
				{
					_bool = [_group, _building] call TCL_Trigger_F;
				};
				
				if ( (_bool) && { (damage _building < 1) } ) then
				{
					_array deleteAt (_array find _building);
					
					if (_group in (TCL_Garrison select 0) ) then
					{
						private _buildings = (_group getVariable "TCL_Garrison");
						
						_buildings pushBack _building;
					}
					else
					{
						(TCL_Garrison select 0) pushBack _group;
						
						(TCL_Garrison select 2) pushBack _group;
						
						_group setVariable ["TCL_Garrison", [_building] ];
					};
					
					(TCL_Garrison select 1) pushBack _building;
					
					// player sideChat format ["TCL_Garrison_F > Group > %1", _group];
					
					[_group, _array] call (TCL_Garrison_F select 2);
					
					// player sideChat format ["TCL_Garrison_F > Building > %1 > %2", _building, (count _array) ];
				};
			};
		};
	};
	
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _return = [];
	
	private _distance = 100;
	
	if (_group in (TCL_Garrison select 0) ) then
	{
		// _distance = 50;
	};
	
	private _leader = (leader _group);
	
	private _objects = nearestObjects [_leader, ["House"], _distance];
	
	_objects = _objects - (TCL_Garrison select 1);
	
	if (_objects isEqualTo [] ) exitWith {_return};
	
	private ["_building","_index","_position"];
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_building = (_objects select _count);
		
		_index = [_building] call TCL_Building_Pos_F;
		
		if ( (_index == 2) && { ( [0,1,2] findIf { (_building buildingPos _x select 2 > 5) } > -1) } ) exitWith
		{
			_return = [_building];
			
			_position = (_building buildingPos _index);
			
			_return pushBack _position;
			
			[_group] spawn (TCL_Garrison_F select 0);
		};
		
		if (_index > 3) exitWith
		{
			_return = [_building];
			
			while { (_index > 0) } do
			{
				_position = (_building buildingPos _index);
				
				if (_return findIf { (_position distance _x > 5) } > -1) then
				{
					_return pushBack _position;
				};
				
				_index = _index - 1;
			};
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_array"];
	
	private _units = (units _group);
	
	_array = _array call TCL_Shuffle_F;
	
	_units = _units - (TCL_Garrison select 3);
	
	_units = _units select { ( (alive _x) && { (isNull objectParent _x) } ) };
	
	if (count _units > count _array) then
	{
		[_group] spawn (TCL_Garrison_F select 0);
	};
	
	private ["_unit","_position"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (_array isEqualTo [] ) exitWith {};
		
		(TCL_Garrison select 3) pushBack _unit;
		
		_position = (_array select 0);
		
		_unit doMove _position;
		
		[_unit, _group, _position] spawn (TCL_Garrison_F select 3);
		
		_array deleteAt (_array find _position);
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Garrison
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_position"];
	
	private _time = (time + 30);
	
	private _distance = (_unit distance _position);
	
	_time = (_time + _distance);
	
	while { ( (alive _unit) && { (time < _time) } ) } do
	{
		if ( (unitReady _unit) || (count (waypoints _group) > 1) ) exitWith
		{
			if (_group in (TCL_Reinforcement select 0) ) then
			{
				_time = time;
			};
		};
		
		sleep 5;
	};
	
	if ( (alive _unit) && { (time < _time) } ) then
	{
		if ( (_unit distance _position > 3) || (count (waypoints _group) > 1) ) exitWith {};
		
		doStop _unit;
	};
	
	TCL_DeleteAT(TCL_Garrison,3,_unit);
	
	}
];