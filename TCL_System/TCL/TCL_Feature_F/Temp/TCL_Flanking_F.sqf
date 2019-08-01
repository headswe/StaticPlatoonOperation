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
	
	private _random = 3 - (random 1);
	
	private _leader = (leader _group);
	
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
	
	if (floor (random 100) < (TCL_Feature select 19) ) exitWith
	{
		(TCL_Flanking select 1) append _array;
		
		// player sideChat format ["TCL_Flanking_F > Flanking #1 > %1 > %2", _group, _array];
	};
	
	if (floor (random 100) < (TCL_Feature select 20) ) exitWith
	{
		_units = _units - _array;
		
		if (floor (random 100) < (TCL_Feature select 21) ) then
		{
			_units deleteAt (_units find _leader);
		};
		
		if (_leader in _units) then
		{
			_units = _units;
			
			// player sideChat format ["TCL_Flanking_F > Flanking #2 > %1 > %2", _group, _units];
		}
		else
		{
			_units = _units select { (floor (random 100) < 50) };
			
			_units pushBack _leader;
			
			// player sideChat format ["TCL_Flanking_F > Flanking #3 > %1 > %2", _group, _units];
		};
		
		(TCL_Flanking select 2) append _units;
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
	
	}
];