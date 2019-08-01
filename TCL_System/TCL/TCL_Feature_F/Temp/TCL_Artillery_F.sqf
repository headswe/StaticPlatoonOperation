#include "TCL_Macros.hpp"

TCL_Artillery_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	if (TCL_Feature select 9) then
	{
		if (floor (random 100) < (TCL_Feature select 10) ) then
		{
			private _condition = (_logic getVariable "TCL_Artillery");
			
			if (_condition select 0) then
			{
				private _objects = [];
				
				private _echo = _group;
				
				private _units = (units _echo);
				
				{_objects append (synchronizedObjects _x) } count _units;
				
				private _leader = (leader _echo);
				
				private _groups = (TCL_Artillery select 0);
				
				_groups = _groups select {_vehicle = (vehicle leader _x); ( (alive _vehicle) && { (alive gunner _vehicle) } && { (canFire _vehicle) } && { (someAmmo _vehicle) } && { (side _echo getFriend side _x > 0.6) } ) };
				
				if (_groups isEqualTo [] ) exitWith {};
				
				private _position = (getPos _logic);
				
				private _distance = [_echo] call (TCL_Radio_F select 0);
				
				private ["_kilo","_vehicle","_bool"];
				
				private _count = 0;
				
				for "_count" from _count to (count _groups - 1) do
				{
					_kilo = (_groups select _count);
					
					_vehicle = (vehicle leader _kilo);
					
					_bool = [_vehicle, _position] call (TCL_Artillery_F select 3);
					
					if ( (_vehicle getVariable "TCL_Artillery") && { (_bool) } && { (_leader distance _vehicle < _distance) } ) exitWith
					{
						// if ( (floor (random 100) < 50) || (_vehicle in _objects) ) then
						
						_condition set [0, False];
						
						_vehicle setVariable ["TCL_Artillery", False];
						
						// player sideChat format ["TCL_Artillery_F > %1", _vehicle];
						
						[_enemy, _kilo, _logic, _vehicle, _condition] spawn (TCL_Artillery_F select 1);
					};
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic","_vehicle","_condition"];
	
	private _value = [_enemy, _group, _logic] call (TCL_KnowsAbout_F select 3);
	
	sleep _value;
	
	private _time = 0;
	
	private _count = 5 - (random 3);
	
	sleep 10 + (random 30);
	
	_condition set [1, True];
	
	private _position = [ (getPos _logic select 0) + (random 100 - random 100), (getPos _logic select 1) + (random 100 - random 100), 0];
	
	private _bool = [_vehicle, _position] call (TCL_Artillery_F select 2);
	
	if (_bool) then
	{
		private _units = (units _group);
		
		_units = _units select { (typeOf _vehicle isEqualTo (typeOf vehicle _x) ) };
		
		if (_units isEqualTo [] ) exitWith {};
		
		[_units, _logic] spawn (TCL_Artillery_F select 4);
		
		// private _time = 0;
		
		private _rounds = 0;
		
		private _magazine = (getArtilleryAmmo [_vehicle] select 0);
		
		_time = _vehicle getArtilleryETA [_position, _magazine];
		
		if (False) then
		{
		
		{
		_vehicle = (vehicle _x);
		
		private _gunner = (gunner _vehicle);
		
		private _muzzle = (currentMuzzle _gunner);
		
		_rounds = (_vehicle ammo _muzzle);
		
		_rounds = (_rounds / _count);
		
		private _magazine = (getArtilleryAmmo [_vehicle] select 0);
		
		_time = _vehicle getArtilleryETA [_position, _magazine];
		
		_vehicle doArtilleryFire [_position, _magazine, _rounds];
		
		sleep (random 5);
		
		} forEach _units;
		
		private _value = (_time * _rounds);
		
		_value = (_value / _count);
		
		// player sideChat format ["TCL_Artillery_F > Artillery > %1 > %2 > %3 > %4", _time, _value, _count, _rounds];
		
		_time = (_time / _count);
		
		private _count = _rounds;
		
		while { (_count > 0) } do
		{
			sleep _time;
			
			_count = _count - 1;
		};
		
		// sleep _value;
		
		};
	};
	
	// player sideChat format ["TCL_Artillery_F > Artillery > %1", _condition];
	
	// _condition set [1, False];
	
	sleep 30 + (random 50);
	
	_vehicle setVariable ["TCL_Artillery", True];
	
	if (_time > 0) then
	{
		sleep 50 + (random 70);
	}
	else
	{
		sleep 30 + (random 50);
	};
	
	_condition set [0, True];
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle","_position"];
	
	private _return = False;
	
	private _gunner = (gunner _vehicle);
	
	if ( (canFire _vehicle) && { (alive _gunner) } ) then
	{
		if (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") then
		{
			private _magazine = (getArtilleryAmmo [_vehicle] select 0);
			
			// _value = getNumber (configFile >> "CfgAmmo" >> _magazine >> "indirectHit");
			
			// player sideChat str _magazine;
			
			// player sideChat str _value;
			
			private _range = _position inRangeOfArtillery [crew _vehicle, _magazine];
			
			if (_range) then
			{
				_return = [_vehicle, _position] call (TCL_Artillery_F select 3);
			};
		};
	};
	
	// player sideChat format ["TCL_Artillery_F > Artillery > %1 > %2", _vehicle, _return];
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle","_position"];
	
	private _return = True;
	
	// private _objects = _position nearEntities [ ["CAManBase","Car","Tank","Helicopter"], 100];
	
	private _objects = _position nearEntities [ ["Man","Car","Tank","Helicopter"], 100];
	
	if (_objects isEqualTo [] ) exitWith {_return};
	
	_array = (allUnits + vehicles);
	
	_objects = allUnits;
	
	private "_object";
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_object = (_objects select _count);
		
		// if ( (alive _object) && { (side _object getFriend side _vehicle > 0.6) } && { (_object in _array) } ) exitWith
		
		if ( (alive _object) && { (side _object getFriend side _vehicle > 0.6) } && { (_object distance _position < 100) } ) exitWith
		{
			_return = False;
			
			// player sideChat format ["TCL_Artillery_F > Artillery > %1 > %2", _object, _vehicle];
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #4
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units","_logic"];
	
	private _time = 0;
	
	private _array = [];
	
	// private _rounds = 0;
	
	private _rounds = 3 + (random 5);
	
	private _position = [ (getPos _logic select 0) + (random 100 - random 100), (getPos _logic select 1) + (random 100 - random 100), 0];
	
	private ["_unit","_vehicle"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		_array pushBack _unit;
		
		_vehicle = (vehicle _unit);
		
		private _gunner = (gunner _vehicle);
		
		private _muzzle = (currentMuzzle _gunner);
		
		// _rounds = (_vehicle ammo _muzzle);
		
		// _rounds = (_rounds / _random);
		
		private _magazine = (getArtilleryAmmo [_vehicle] select 0);
		
		_time = _vehicle getArtilleryETA [_position, _magazine];
		
		_vehicle doArtilleryFire [_position, _magazine, _rounds];
		
		sleep (random 5);
	};
	
	if (_array isEqualTo _units) then
	{
		while { (currentcommand _vehicle isEqualTo "FIRE AT POSITION") } do
		{
			sleep 5;
		};
		
		sleep _time;
		
		private _condition = (_logic getVariable "TCL_Artillery");
		
		_condition set [1, False];
		
		// player sideChat format ["TCL_Artillery_F > Artillery > %1", _condition];
	};
	
	}
];