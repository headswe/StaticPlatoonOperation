#include "TCL_Macros.hpp"

TCL_Static_Weapon_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group"];
	
	private _units = (units _group);
	
	private _array = ( (TCL_Static_Weapon select 0) + (TCL_House_Search select 0) );
	
	_units = _units - _array;
	
	private _leader = (leader _group);
	
	_units deleteAt (_units find _leader);
	
	_units = _units select { ( (alive _x) && { (isNull objectParent _x) } ) };
	
	if (count _units > 1) then
	{
		private _unit = _units select (count _units - 1);
		
		private _vehicle = [_unit, _group] call (TCL_Static_Weapon_F select 1);
		
		if (alive _vehicle) then
		{
			private _bool = True;
			
			if (_group in (TCL_Hold select 0) ) then
			{
				_bool = [_group, _vehicle] call TCL_Trigger_F;
			};
			
			if (_bool) then
			{
				[_unit, _group, _vehicle] spawn (TCL_Static_Weapon_F select 2);
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	private _return = objNull;
	
	private _leader = (leader _group);
	
	private _objects = _unit nearEntities ["StaticWeapon", 100];
	
	if (_objects isEqualTo [] ) exitWith {_return};
	
	_objects = _objects - (TCL_Static_Weapon select 1);
	
	_objects = _objects select { ( (alive _x) && { (someAmmo _x) } && { (_unit knowsAbout _x > 0) } && { (_x distance _leader < 100) } ) };
	
	private ["_vehicle","_side","_crew"];
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_vehicle = (_objects select _count);
		
		_side = False;
		
		if (getNumber (configFile >> "CfgVehicles" >> (typeOf _unit) >> "side") isEqualTo getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "side") ) then
		{
			_side = True;
		};
		
		_crew = (crew _vehicle);
		
		if ( (_side) && { (_crew isEqualTo [] ) } ) exitWith
		{
			_return = _vehicle;
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_vehicle"];
	
	_unit disableAI "AUTOTARGET";
	
	_unit assignAsGunner _vehicle;
	
	_unit doMove (getPos _vehicle);
	
	(TCL_Static_Weapon select 0) pushBack _unit;
	
	(TCL_Static_Weapon select 1) pushBack _vehicle;
	
	[_unit] orderGetIn True; [_unit] allowGetIn True;
	
	private _time = (time + 30);
	
	private _distance = (_unit distance _vehicle);
	
	_time = (_time + _distance);
	
	while { ( (alive _unit) && { (time < _time) } && { (isNull objectParent _unit) } ) } do
	{
		sleep 5;
	};
	
	if ( (alive _unit) && { (time < _time) } && { (_unit == gunner _vehicle) } ) then
	{
		_unit enableAI "AUTOTARGET";
		
		[_unit, _group, _vehicle] spawn (TCL_Static_Weapon_F select 3);
	}
	else
	{
		TCL_DeleteAT(TCL_Static_Weapon,0,_unit);
		
		TCL_DeleteAT(TCL_Static_Weapon,1,_vehicle);
		
		_unit leaveVehicle _vehicle; [_unit] orderGetIn False; [_unit] allowGetIn False;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Static Weapon
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_vehicle"];
	
	private _units = (units _group);
	
	private _behaviour = (behaviour _unit);
	
	if (_behaviour isEqualTo "COMBAT") then
	{
		{_x disableAI "AUTOCOMBAT"} count _units;
		
		_group setBehaviour "AWARE";
	};
	
	// (TCL_Static_Weapon select 0) pushBack _unit;
	
	// (TCL_Static_Weapon select 1) pushBack _vehicle;
	
	private ["_leader","_time","_random","_waypoint"];
	
	while { ( (alive _unit) && { (_unit == gunner _vehicle) } ) } do
	{
		_leader = (leader _group);
		
		if ( (canFire _vehicle) && { (someAmmo _vehicle) } ) then
		{
			_enemy = (_group getVariable "TCL_Enemy");
			
			if ( (alive _enemy) && { (_unit knowsAbout vehicle _enemy > 0) } ) then
			{
				_time = (time + 10);
				
				_random = (random 30);
				
				if (True) exitWith
				{
					_magazine = (getArtilleryAmmo [_vehicle] select 0);
					
					_range = (getPos _enemy) inRangeOfArtillery [crew _vehicle, _magazine];
					
					if (_range) then
					{
						private _count = (random 3);
						
						while { (_count > 0) } do
						{
							_vehicle doArtilleryFire [ (getPos _enemy), _magazine, 1];
							
							sleep 3 + (random 5);
							
							_count = _count - 1;
						};
					};
					
					player sideChat format ["TCL_Static_Weapon_F > Vehicle > %1 > %2 > %3 > %4", _range, _enemy, _vehicle, _magazine];
					
					sleep 10 + (random 30);
				};
				
				_vehicle doTarget _enemy;
				
				_time = (_time + _random);
				
				while { (time < _time) } do
				{
					if (_vehicle aimedAtTarget [_enemy] > 0) exitWith
					{
						_vehicle fireAtTarget [_enemy];
						
						// player sideChat format ["TCL_Static_Weapon_F > Vehicle > %1", _vehicle];
						
						sleep 10 + (random 30);
					};
					
					sleep 1;
				};
			};
		}
		else
		{
			_unit leaveVehicle _vehicle; [_unit] orderGetIn False; [_unit] allowGetIn False;
		};
		
		_group = (group _unit);
		
		_waypoint = (_group getVariable "TCL_Waypoint");
		
		// player sideChat format ["TCL_Static_Weapon_F > %1", _unit];
		
		if ( (_unit distance _leader > 100) || (_unit distance _waypoint > 500) ) exitWith
		{
			_unit leaveVehicle _vehicle; [_unit] orderGetIn False; [_unit] allowGetIn False;
		};
		
		sleep 5;
	};
	
	if (_unit == gunner _vehicle) then
	{
		_unit leaveVehicle _vehicle; [_unit] orderGetIn False; [_unit] allowGetIn False;
	};
	
	_group setBehaviour _behaviour;
	
	TCL_DeleteAT(TCL_Static_Weapon,0,_unit);
	
	sleep 10 + (random 30);
	
	TCL_DeleteAT(TCL_Static_Weapon,1,_vehicle);
	
	}
];