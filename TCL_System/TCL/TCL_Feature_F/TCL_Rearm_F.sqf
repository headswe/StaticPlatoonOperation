#include "TCL_Macros.hpp"

TCL_Rearm_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	private ["_ammo","_count","_magazine","_magazines","_array"];
	
	private _weapon = (primaryWeapon _unit);
	
	if (_weapon isEqualTo "") then
	{
		_ammo = 0;
		
		_count = 0;
		
		_magazine = "";
		
		_magazines = [];
	}
	else
	{
		_magazines = getArray (configfile >> "CfgWeapons" >> _weapon >> "magazines");
		
		_magazine = (_magazines select 0);
		
		_array = [];
		
		_array = (magazines _unit) select { (_x in _magazines) };
		
		_count = (count _array);
		
		_ammo = (_unit ammo _weapon);
	};
	
	if ( (_count < 3) && { (_ammo < 50) } ) then
	{
		[_unit, _group, _magazine, _magazines] call (TCL_Rearm_F select 1);
		
		// player sideChat format ["TCL_Rearm_F > Magazine > %1 > %2 > %3 > %4", _unit, _ammo, _count, _magazine];
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_magazine","_magazines"];
	
	if (alive _unit) then
	{
		private _objects = nearestObjects [_unit, ["CAManBase"], 100];
		
		_objects = _objects - (TCL_Rearm select 2);
		
		private _array = [];
		
		_array = _objects select { ( (alive _x) || (_unit knowsAbout _x == 0) ) };
		
		_objects = _objects - _array;
		
		if (_objects isEqualTo [] ) exitWith
		{
			_objects = nearestObjects [_unit, ["LandVehicle"], 100];
			
			_objects = _objects - (TCL_Rearm select 2);
			
			_objects = _objects select { ( (alive _x) && { (crew _x isEqualTo [] ) } ) };
			
			if (_objects isEqualTo [] ) exitWith {};
			
			private _object = (_objects select 0);
			
			_array = (magazineCargo _object);
			
			if (_array isEqualTo [] ) exitWith {};
			
			if (_magazine in _array) then
			{
				(TCL_Rearm select 0) pushBack _unit;
				
				// (TCL_Rearm select 1) pushBack _unit;
				
				(TCL_Rearm select 2) pushBack _object;
				
				_array = _array select { (_x in _magazines) };
				
				[_unit, _group, _object, _array] spawn (TCL_Rearm_F select 3);
				
				// player sideChat format ["TCL_Rearm_F > Vehicle > %1 > %2", _unit, _object];
			};
		};
		
		private _object = (_objects select 0);
		
		private _bool = [_unit, _group, _objects, _magazine, _magazines] call (TCL_Rearm_F select 2);
		
		if (_bool) then
		{
			_objects = nearestObjects [_object, ["WeaponHolderSimulated"], 5];
			
			_objects = _objects - (TCL_Rearm select 2);
			
			if (_objects isEqualTo [] ) exitWith {};
			
			private _dummy = (_objects select 0);
			
			private _weapons = (weaponCargo _dummy);
			
			private _weapon = (_weapons select 0);
			
			(TCL_Rearm select 0) pushBack _unit;
			
			// (TCL_Rearm select 1) pushBack _unit;
			
			(TCL_Rearm select 2) pushBack _object;
			
			// _array = [_object, _dummy];
			
			// (TCL_Rearm select 2) append _array;
			
			[_unit, _group, _object, _dummy, _weapon] spawn (TCL_Rearm_F select 3);
			
			// player sideChat format ["TCL_Rearm_F > Weapon > %1 > %2", _unit, _object];
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_objects","_magazine","_magazines"];
	
	private _return = True;
	
	if (_magazine isEqualTo "") exitWith {_return};
	
	private ["_object","_array"];
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_object = (_objects select _count);
		
		_array = (magazines _object);
		
		if (_magazine in _array) exitWith
		{
			_return = False;
			
			(TCL_Rearm select 0) pushBack _unit;
			
			// (TCL_Rearm select 1) pushBack _unit;
			
			(TCL_Rearm select 2) pushBack _object;
			
			_array = _array select { (_x in _magazines) };
			
			[_unit, _group, _object, _array] spawn (TCL_Rearm_F select 3);
			
			// player sideChat format ["TCL_Rearm_F > Magazines > %1 > %2", _unit, _object];
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_object"];
	
	private _bool = True;
	
	private _time = (time + 10);
	
	private _position = (getPos _object);
	
	private _boundingBox = (boundingBox _object select 1 select 1);
	
	_boundingBox = (_boundingBox - 1);
	
	if (_boundingBox < 1) then
	{
		_boundingBox = (_boundingBox + 1);
	};
	
	_position set [1, (_position select 1) - _boundingBox];
	
	_unit forceSpeed -1;
	
	_unit doMove _position;
	
	// (TCL_Rearm select 0) pushBack _unit;
	
	(TCL_Rearm select 1) pushBack _unit;
	
	// (TCL_Rearm select 2) pushBack _object;
	
	private _distance = (_unit distance _object);
	
	// player sideChat format ["TCL_Rearm_F > BoundingBox > %1 > %2 > %3", _unit, _object, _boundingBox];
	
	_time = (_time + _distance);
	
	while { ( (alive _unit) && { (time < _time) } ) } do
	{
		if (_unit distance _position < _boundingBox) exitWith
		{
			_bool = False;
			
			_unit forceSpeed 0;
			
			_unit doWatch _object;
			
			_unit setUnitPos "MIDDLE";
			
			sleep 1;
			
			if (count _this == 4) then
			{
				private _magazines = (_this select 3);
				
				[_unit, _group, _object, _magazines] spawn (TCL_Rearm_F select 4);
			}
			else
			{
				private _dummy = (_this select 3);
				
				private _weapon = (_this select 4);
				
				[_unit, _group, _object, _dummy, _weapon] spawn (TCL_Rearm_F select 5);
			};
		};
		
		sleep 1;
	};
	
	if (_bool) then
	{
		[_unit, _group, _object, _bool] spawn (TCL_Rearm_F select 6);
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #4
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_object","_magazines"];
	
	if (alive _unit) then
	{
		private _bool = False;
		
		private _magazine = (_magazines select 0);
		
		_unit action ["TakeMagazine", _object, _magazine];
		
		_magazines deleteAt (_magazines find _magazine);
		
		private _count = (count magazines _unit);
		
		private _array = [];
		
		private _index = 0;
		
		{_unit addMagazine _x;
		
		if (count magazines _unit isEqualTo _count) exitWith
		{
			_bool = True;
		};
		
		_count = (count magazines _unit);
		
		_index = _index + 1;
		
		_array = _array + [_x];
		
		_object removeMagazine _x;
		
		} count _magazines;
		
		if (alive _object) then
		{
			_magazines = (magazineCargo _object);
			
			clearMagazineCargo _object;
			
			_count = 0;
			
			for "_count" from _count to (count _magazines - 1) do
			{
				_magazine = (_magazines select _count);
				
				if (_magazine in _array) then
				{
					_array deleteAt (_array find _magazine);
					
					// player sideChat format ["TCL_Rearm_F > Magazines > %1 > %2", _unit, _array];
				}
				else
				{
					_object addMagazineCargo [_magazine, 1];
				};
			};
		};
		
		if (count _magazines > _index) then
		{
			_bool = True;
		};
		
		// player sideChat format ["TCL_Rearm_F > Magazines > %1 > %2", _unit, _bool];
		
		sleep 3;
		
		_unit selectWeapon (primaryWeapon _unit);
		
		[_unit, _group, _object, _bool] spawn (TCL_Rearm_F select 6);
		
		// player sideChat format ["TCL_Rearm_F > Magazines > %1", _unit];
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #5
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_object","_dummy","_weapon"];
	
	if (alive _unit) then
	{
		private _bool = True;
		
		private _magazines = getArray (configfile >> "CfgWeapons" >> _weapon >> "magazines");
		
		private _array = [];
		
		_array = (magazines _object) select { (_x in _magazines) };
		
		if (_array isEqualTo [] ) then
		{
			_bool = False;
			
			(TCL_Rearm select 2) pushBack _dummy;
		}
		else
		{
			if (primaryWeapon _unit isEqualTo "") then
			{
			
			}
			else
			{
				_unit action ["DropWeapon", _dummy, (primaryWeapon _unit) ];
				
				sleep 3;
			};
			
			_unit action ["TakeWeapon", _dummy, _weapon];
			
			sleep 3;
			
			_unit action ["REARM", _object];
			
			_unit selectWeapon (primaryWeapon _unit);
			
			// player sideChat format ["TCL_Rearm_F > Weapon > %1", _unit];
		};
		
		[_unit, _group, _dummy, _bool] spawn (TCL_Rearm_F select 6);
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm Function #6
	// ////////////////////////////////////////////////////////////////////////////
	// Rearm
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_object","_bool"];
	
	_unit forceSpeed -1;
	
	_unit doWatch objNull;
	
	_unit setUnitPos "AUTO";
	
	TCL_DeleteAT(TCL_Rearm,0,_unit);
	
	[_unit, _group] call (TCL_Follow_F select 0);
	
	if (_bool) then
	{
		sleep 10 + (random 30);
		
		TCL_DeleteAT(TCL_Rearm,2,_object);
	}
	else
	{
		sleep 30 + (random 50);
	};
	
	TCL_DeleteAT(TCL_Rearm,1,_unit);
	
	}
];