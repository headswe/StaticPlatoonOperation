#include "TCL_Macros.hpp"

TCL_Advancing_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Advancing Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_object","_weapon","_muzzle"];
	
	private _return = 0;
	
	private _array = ["Throw","Put"];
	
	if (_weapon in _array) exitWith {_return};
	
	private _type = {_weapon isKindOf [_this, configFile >> "CfgWeapons"] };
	
	if ( ("Pistol" call _type) || ("Rifle" call _type) ) then
	{
		private _muzzle = (currentMuzzle _object);
		
		if (_weapon isEqualTo _muzzle) then
		{
			private _accessories = (_object weaponAccessories _muzzle);
			
			private _suppressor = (_accessories select 0);
			
			_return = (TCL_Feature select 24);
			
			if (_suppressor isEqualTo "") then
			{
				_return = (TCL_Feature select 26);
			};
		}
		else
		{
			_return = (TCL_Feature select 24);
		};
	}
	else
	{
		if ("Launcher" call _type) then
		{
			_return = (TCL_Feature select 25);
		}
		else
		{
			_return = (TCL_Feature select 26);
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_object","_group","_value"];
	
	private _leader = (leader _group);
	
	private _distance = (_object distance _leader);
	
	if (_distance < _value) then
	{
		[_object, _group, _distance] spawn (TCL_Advancing_F select 2);
		
		// player sideChat format ["TCL_Advancing_F > Group > %1", _group];
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_object","_group","_distance"];
	
	private _units = (units _group);
	
	private _array = ( (TCL_Hold select 0) + (TCL_Defend select 0) + (TCL_Freeze select 0) + (TCL_Default select 0) + (TCL_Garrison select 0) );
	
	if (_group in (TCL_Garrison select 0) ) then
	{
		_units = _units select { ( (isNull objectParent _x) && { (currentCommand _x isEqualTo "") } ) };
		
		if (_units isEqualTo [] ) exitWith {};
		
		_array deleteAt (_array find _group);
		
		// player sideChat format ["TCL_Advancing_F > Garrison > %1", _units];
	};
	
	if (_group in _array) then
	{
		[_object, _group, _distance] spawn (TCL_Advancing_F select 3);
	}
	else
	{
		if ( (floor (random 100) < 35) && { (_distance > 100) } && { (_group knowsAbout vehicle _object == 0) } ) then
		{
			private _leader = (leader _group);
			
			private _behaviour = (behaviour _leader);
			private _speedMode = (speedMode _leader);
			
			_units select { ( (_x == _leader) || (floor (random 100) < 50) ) } apply {_x doWatch (getPos _object) };
			
			if (_distance > 300) then
			{
				if (_leader hasWeapon "Binocular") then {_leader selectWeapon "Binocular"};
			};
			
			sleep 5 + (random 10);
			
			if (currentWeapon _leader isEqualTo "Binocular") then
			{
				_leader selectWeapon (primaryWeapon _leader);
			};
			
			if (_group knowsAbout vehicle _object == 0) then
			{
				_group setBehaviour "AWARE";
				_group setSpeedMode "NORMAL";
				
				if (floor (random 100) < 50) then
				{
					_group setSpeedMode "FULL";
				};
				
				(TCL_Advancing select 0) pushBack _group;
				
				_group lockWp True;
				
				private _value = 50;
				
				if (alive _object) then
				{
					_value = 30; 
				};
				
				private _position = [ (getPos _object select 0) + (random _value - random _value), (getPos _object select 1) + (random _value - random _value), 0];
				
				if (_group in (TCL_Garrison select 0) ) then
				{
					_units doMove _position;
				}
				else
				{
					_group move _position;
					
					_units doFollow _leader;
				};
				
				private _bool = True;
				
				private _count = (random 50);
				
				while { (_count > 0) } do
				{
					if ( (_group in (TCL_Reinforcement select 0) ) || ( (alive _object) && { (_group knowsAbout vehicle _object > 0) } ) ) exitWith
					{
						_bool = False;
					};
					
					_count = _count - 1;
					
					sleep 1;
				};
				
				TCL_DeleteAT(TCL_Advancing,0,_group);
				
				if (_group in (TCL_Garrison select 0) ) then
				{
					{_x doMove (getPos _x) } count _units;
					
					sleep 10 + (random 30);
				};
				
				_group move (getPos _leader);
			};
			
			sleep 10 + (random 30);
			
			if (_group in (TCL_Reinforcement select 0) ) then
			{
				_bool = False;
			}
			else
			{
				_group lockWp False;
				
				_group setBehaviour _behaviour;
				_group setSpeedMode _speedMode;
				
				if (count waypoints _group == 1) then
				{
					private _position = (_group getVariable "TCL_Position");
					
					private _value = 50;
					
					if ( (alive _object) && { (_group knowsAbout vehicle _object > 0) } && { (side _group getFriend side _object > 0.6) } )then
					{
						private _random = (random 50);
						
						_value = (_value + _random);
					};
					
					if (floor (random 100) < _value) then
					{
						_group move _position;
					};
				};
			};
		}
		else
		{
			[_object, _group, _distance] spawn (TCL_Advancing_F select 3);
		};
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Advancing
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_object","_group","_distance"];
	
	sleep (random 1);
	
	private _array = [];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	{if ( (floor (random 100) < 5) && { (alive _object) } ) then {_x setUnitPos "DOWN"} else {if (floor (random 100) < 35) then {_x setUnitPos "MIDDLE"} } } count _units;
	
	_units select { ( (_x == _leader) || (floor (random 100) < 50) ) } apply {_x doWatch (getPos _object); _array pushBack _x};
	
	// {if ( (floor (random 100) < 50) || (_x == _leader) ) then {_x doWatch (getPos _object); _array pushBack _x} } forEach _units;
	
	(TCL_Watch select 0) append _array;
	
	if (_distance > 300) then
	{
		if (_leader hasWeapon "Binocular") then {_leader selectWeapon "Binocular"};
	};
	
	sleep (random 30);
	
	if (currentWeapon _leader isEqualTo "Binocular") then
	{
		_leader selectWeapon (primaryWeapon _leader);
	};
	
	TCL_Watch set [0, (TCL_Watch select 0) - _array];
	
	if (_group in (TCL_Suppressed select 0) ) then {_group = _group} else { {_x setUnitPos "AUTO"} count _units};
	
	}
];