#include "TCL_Macros.hpp"

TCL_Flanking_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Flanking Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _array = [];
	
	private _units = (units _group);
	
	if (count _units > 1) then
	{
	
	private _random = 3 - (random 1);
	
	_value = (count _units / _random);
	
	(TCL_Flanking select 0) pushBack _group;
	
	private "_unit";
	
	private _count = (count _units - 1);
	
	while { (_count > _value) } do
	{
		_unit = (_units select _count);
		
		_array pushBack _unit;
		
		_count = _count - 1;
	};
	
	if (floor (random 100) < (TCL_Feature select 20) ) then
	{
		(TCL_Flanking select 1) append _array;
		
		player sideChat format ["TCL_Flanking_F > Flanking #1 > %1 > %2", _group, _array];
	}
	else
	{
		_units = _units - _array;
		
		if (floor (random 100) < (TCL_Feature select 21) ) then
		{
			(TCL_Flanking select 1) append _array;
			
			(TCL_Flanking select 2) append _units;
			
			player sideChat format ["TCL_Flanking_F > Flanking #2 > %1 > %2", _group, _units];
		}
		else
		{
			if (floor (random 100) < (TCL_Feature select 22) ) then
			{
				_units = _units select { (floor (random 100) < 75) };
				
				// _units = (_units / _random);
				
				(TCL_Flanking select 1) append _array;
				
				(TCL_Flanking select 2) append _units;
				
				player sideChat format ["TCL_Flanking_F > Flanking #3 > %1 > %2", _group, _units];
			};
		};
	};
	
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_enemy","_position","_distance"];
	
	private _value = 30;
	
	private _bool = True;
	
	private _random = (random 50);
	
	_value = (_value + _random);
	
	private _direction = (_unit getDir _enemy);
	
	if (_unit in (TCL_Flanking select 1) ) then
	{
		_direction = (_direction + _value);
	}
	else
	{
		if (_unit in (TCL_Flanking select 2) ) exitWith
		{
			_direction = (_direction - _value);
		};
		
		_bool = False;
	};
	
	if (_bool) then
	{
		_position = [_unit, _distance, _direction] call TCL_Real_Pos_F;
		
		if (TCL_Debug select 6) then
		{
			[_position] spawn (TCL_Flanking_F select 2);
		};
		
		// player sideChat format ["TCL_Take_Cover_F > Direction > %1 > %2", _unit, _direction];
	};
	
	_position
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_position"];
	
	private _spot = createVehicle ["Sign_Arrow_Large_Yellow_F", _position, [], 0, "CAN_COLLIDE"];
	
	sleep 5;
	
	deleteVehicle _spot;
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_flanking"];
	
	if (_group in (TCL_Flanking select 0) ) then
	{
		player sideChat format ["TCL_System > Flanking Out > %1", _group];
		
		if (_flanking) then
		{
			(TCL_Flanking select 0) deleteAt ( (TCL_Flanking select 0) find _group);
			
			TCL_Flanking set [1, (TCL_Flanking select 1) - units _group];
			
			TCL_Flanking set [2, (TCL_Flanking select 2) - units _group];
		};
	}
	else
	{
		_flanking = True;
		
		[_group] call (TCL_Flanking_F select 0);
		
		if (_flanking) then
		{
			// (TCL_Flanking select 0) pushBack _group;
			
			player sideChat format ["TCL_System > Flanking In > %1", _group];
		};
	};
	
	}
];