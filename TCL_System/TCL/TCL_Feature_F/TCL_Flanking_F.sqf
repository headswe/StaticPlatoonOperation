#include "TCL_Macros.hpp"

TCL_Flanking_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Flanking Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Flanking
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _units = (units _group);
	
	if ( { (alive _x) } count _units > 3) then
	{
		private _array = [];
		
		private _random = 3 - (random 1);
		
		private _value = (count _units / 2);
		
		// _value = (count _units / _random);
		
		if (floor (random 100) < (TCL_Feature select 20) ) then
		{
			(TCL_Flanking select 0) pushBack _group;
			
			// player sideChat format ["TCL_System > Flanking In > %1", _group];
		};
		
		private "_unit";
		
		private _count = (count _units - 1);
		
		while { (_count > _value) } do
		{
			_unit = (_units select _count);
			
			_array pushBack _unit;
			
			_count = _count - 1;
		};
		
		(TCL_Flanking select 1) append _array;
		
		if (floor (random 100) < (TCL_Feature select 21) ) then
		{
			// player sideChat format ["TCL_Flanking_F > Flanking #1 > %1 > %2", _group, _array];
		}
		else
		{
			_units = _units - _array;
			
			private _leader = (leader _group);
			
			_units deleteAt (_units find _leader);
			
			private _unit = (_units select 0);
			
			_units deleteAt (_units find _unit);
			
			(TCL_Flanking select 2) append _units;
			
			// player sideChat format ["TCL_Flanking_F > Flanking #3 > %1 > %2 > %3", _group, _units, _array];
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
		if (_group in (TCL_Flanking select 3) ) exitWith
		{
			_direction = (_direction + _value);
		};
		
		_direction = (_direction - _value);
	}
	else
	{
		if (_unit in (TCL_Flanking select 2) ) exitWith
		{
			if (_group in (TCL_Flanking select 3) ) exitWith
			{
				_direction = (_direction - _value);
			};
			
			_direction = (_direction + _value);
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
	{params ["_group"];
	
	if (_group in (TCL_Flanking select 0) ) then
	{
		TCL_DeleteAT(TCL_Flanking,0,_group);
		
		// player sideChat format ["TCL_System > Flanking Out > %1", _group];
	}
	else
	{
		(TCL_Flanking select 0) pushBack _group;
		
		// player sideChat format ["TCL_System > Flanking In > %1", _group];
	};
	
	True
	
	}
];