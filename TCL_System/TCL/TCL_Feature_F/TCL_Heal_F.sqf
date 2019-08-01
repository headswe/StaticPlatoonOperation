#include "TCL_Macros.hpp"

TCL_Heal_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Heal Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Heal
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	private _damage = (_unit getHitPointDamage "hitlegs");
	
	if ( (_damage > 0.5) || (damage _unit > 0.5) ) then
	{
		private _items = (items _unit);
		
		if ("FirstAidKit" in _items) then
		{
			(TCL_Heal select 1) pushBack _unit;
			
			_unit action ["HealSoldierSelf", _unit];
			
			[_unit, _group] spawn (TCL_Heal_F select 2);
			
			// player sideChat format ["TCL_Heal_F > Heal > %1 > %2", _unit, (damage _unit) ];
		}
		else
		{
			private _units = (units _group);
			
			_units = _units - (TCL_Heal select 1);
			
			_units = _units select {_items = (items _x); ( (alive _x) && { (isNull objectParent _x) } && { ("Medikit" in _items) } ) };
			
			if (_units isEqualTo [] ) exitWith
			{
				[_unit, _group] call (TCL_Heal_F select 1);
			};
			
			private _object = (_units select 0);
			
			private _array = [_unit, _object];
			
			(TCL_Heal select 0) append _array;
			
			(TCL_Heal select 1) append _array;
			
			[_unit, _group, _object] spawn (TCL_Heal_F select 2);
			
			// player sideChat format ["TCL_Heal_F > Medic > %1 > %2", _unit, _object];
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Heal Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Heal
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	if (alive _unit) then
	{
		private _objects = nearestObjects [_unit, ["CAManBase"], 100];
		
		_objects = _objects - (TCL_Heal select 2);
		
		private _array = _objects select { (alive _x) };
		
		_objects = _objects - _array;
		
		if (_objects isEqualTo [] ) exitWith {};
		
		private _object = (_objects select 0);
		
		(TCL_Heal select 2) pushBack _object;
		
		private _items = (items _object);
		
		_items = _items select { ( (_x isEqualTo "Medikit") || (_x isEqualTo "FirstAidKit") ) };
		
		if (_items isEqualTo [] ) exitWith {};
		
		(TCL_Heal select 0) pushBack _unit;
		
		(TCL_Heal select 1) pushBack _unit;
		
		private _item = (_items select 0);
		
		[_unit, _group, _object, _item] spawn (TCL_Heal_F select 2);
		
		// player sideChat format ["TCL_Heal_F > Medikit > %1 > %2", _unit, _object];
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Heal Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Heal
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	if (alive _unit) then
	{
		if (count _this == 2) then
		{
			sleep 30 + (random 50);
			
			TCL_DeleteAT(TCL_Heal,1,_unit);
		}
		else
		{
			private _object = (_this select 2);
			
			if (count _this == 3) then
			{
				if (_unit distance _object < 100) then
				{
					[_unit, _group, _object] spawn (TCL_Heal_F select 3);
				}
				else
				{
					TCL_DeleteAT(TCL_Heal,0,_unit);
					
					TCL_DeleteAT(TCL_Heal,0,_object);
					
					sleep 10 + (random 30);
					
					TCL_DeleteAT(TCL_Heal,1,_unit);
					
					TCL_DeleteAT(TCL_Heal,1,_object);
				};
			}
			else
			{
				private _item = (_this select 3);
				
				_unit forceSpeed -1;
				
				private _bool = True;
				
				private _time = (time + 10);
				
				_unit doMove (getPos _object);
				
				private _distance = (_unit distance _object);
				
				_time = (_time + _distance);
				
				while { ( (alive _unit) && { (time < _time) } ) } do
				{
					if (_unit distance _object < 1) exitWith
					{
						_bool = False;
						
						_unit addItem _item;
						
						_object removeItem _item; 
						
						_unit action ["HealSoldierSelf", _unit];
						
						TCL_DeleteAT(TCL_Heal,2,_object);
					};
					
					sleep 1;
				};
				
				if (_bool) then
				{
					TCL_DeleteAT(TCL_Heal,2,_object);
				};
				
				TCL_DeleteAT(TCL_Heal,0,_unit);
				
				sleep 30 + (random 50);
				
				TCL_DeleteAT(TCL_Heal,1,_unit);
			};
		};
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Heal Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Heal
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_object"];
	
	if (alive _unit) then
	{
		_unit setUnitPos "MIDDLE";
		
		_unit forceSpeed 0;
		
		_object forceSpeed -1;
		
		_object doMove (getPos _unit);
		
		private _time = (time + 10);
		
		private _distance = (_unit distance _object);
		
		_time = (_time + _distance);
		
		while { ( (alive _unit) && { (alive _object) } && { (time < _time) }  ) } do
		{
			if (_object distance _unit < 3) exitWith
			{
				_unit doWatch _object;
				
				_object doWatch _unit;
				
				_object action ["HealSoldier", _unit];
				
				sleep 5;
				
				_unit doWatch objNull;
				
				_object doWatch objNull;
			};
			
			sleep 1;
		};
		
		_unit forceSpeed -1;
		
		_unit setUnitPos "AUTO";
	};
	
	TCL_DeleteAT(TCL_Heal,0,_unit);
	
	TCL_DeleteAT(TCL_Heal,0,_object);
	
	[_object, _group] call (TCL_Follow_F select 0);
	
	sleep 30 + (random 50);
	
	TCL_DeleteAT(TCL_Heal,1,_unit);
	
	TCL_DeleteAT(TCL_Heal,1,_object);
	
	}
];