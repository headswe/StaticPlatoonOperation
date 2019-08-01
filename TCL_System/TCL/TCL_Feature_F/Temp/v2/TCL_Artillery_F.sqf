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
				private _echo = _group;
				
				private _leader = (leader _echo);
				
				private _groups = (TCL_Artillery select 0);
				
				_groups = _groups select {_vehicle = (vehicle leader _x); ( (alive _vehicle) && { (alive gunner _vehicle) } && { (canFire _vehicle) } && { (someAmmo _vehicle) } && { (side _echo getFriend side _x > 0.6) } ) };
				
				if (_groups isEqualTo [] ) exitWith {};
				
				private _position = (getPos _logic);
				
				private _distance = [_echo] call (TCL_Radio_F select 0);
				
				private ["_kilo","_vehicle","_string","_magazine","_range"];
				
				private _count = 0;
				
				for "_count" from _count to (count _groups - 1) do
				{
					_kilo = (_groups select _count);
					
					_vehicle = (vehicle leader _kilo);
					
					// _string = getText ( (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0);
					
					// if (_string isEqualTo "Artillery") then
					
					if (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") then
					{
						_magazine = (getArtilleryAmmo [_vehicle] select 0);
						
						_range = _position inRangeOfArtillery [crew _vehicle, _magazine];
						
						// player sideChat format ["TCL_Artillery_F > Range > %1 > %2", _range, _vehicle];
						
						if ( (_vehicle getVariable "TCL_Artillery") && { (_range) } && { (_leader distance _vehicle < _distance) } ) then
						{
							_condition set [0, False];
							
							_vehicle setVariable ["TCL_Artillery", False];
							
							[_enemy, _kilo, _logic, _vehicle, _condition] spawn (TCL_Artillery_F select 1);
							
							// player sideChat format ["TCL_Artillery_F > Range > %1 > %2", _range, _vehicle];
						};
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
	
	private _sleep = [_enemy, _group, _logic] call (TCL_KnowsAbout_F select 3);
	
	sleep _sleep;
	
	// private _bool = [_logic, _vehicle] call (TCL_Artillery_F select 2);
	
	if (True) then
	{
		private _count = 3;
		
		sleep 5 + (random 10);
		
		private _gunner = (gunner _vehicle);
		
		if ( (alive _vehicle) && { (alive _gunner) } ) then
		{
			private _time = 0;
			
			private _count = 3;
			
			_condition set [1, True];
			
			private _skill = [_group] call TCL_Accuracy_F;
			
			private _magazine = (getArtilleryAmmo [_vehicle] select 0);
			
			private _rounds = (_vehicle ammo currentMuzzle _gunner);
			
			_rounds = (_rounds / _count);
			
			private ["_position","_bool"];
			
			while { ( (alive _vehicle) && { (alive _gunner) } && { (_count > 0) } ) } do
			{
				_position = [ (getPos _logic select 0) + (random 100 - random 100), (getPos _logic select 1) + (random 100 - random 100), 0];
				
				_bool = [_vehicle, _position] call (TCL_Artillery_F select 2);
				
				if (_bool) then
				{
					_time = _vehicle getArtilleryETA [_position, _magazine];
					
					_vehicle doArtilleryFire [_position, _magazine, _rounds];
					
					// player sideChat format ["TCL_Artillery_F > Artillery > %1 > %2 > %3", _vehicle, _time, _rounds];
					
					sleep (_time / _skill);
				};
				
				_count = _count - 1;
			};
			
			sleep _time;
			
			_condition set [1, False];
			
			sleep 30 + (random 50);
			
			_vehicle setVariable ["TCL_Artillery", True];
			
			sleep 50 + (random 70);
		};
	}
	else
	{
		sleep 30 + (random 50);
		
		_vehicle setVariable ["TCL_Artillery", True];
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
			
			player sideChat format ["TCL_Artillery_F > Artillery > %1 > %2", _object, _vehicle];
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle"];
	
	private _magazine = "";
	
	if (canFire _vehicle) then
	{
		if (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") then
		{
			_magazine = (getArtilleryAmmo [_vehicle] select 0);
			
			_range = _position inRangeOfArtillery [crew _vehicle, _magazine];
			
			if (_range) exitWith
			{
				_magazine;
			};
			
			_magazine = "";
		};
	};
	
	_magazine
	
	};
];