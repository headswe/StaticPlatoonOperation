#include "TCL_Macros.hpp"

TCL_Vehicle_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic"];
	
	private _units = (units _group);
	
	private ["_unit","_vehicle","_gunner","_driver"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (isNull objectParent _unit) then
		{
			[_unit] orderGetIn False; [_unit] allowGetIn False;
		}
		else
		{
			if (assignedVehicleRole _unit select 0 == "Cargo") then
			{
				[_unit] orderGetIn False; [_unit] allowGetIn False;
			}
			else
			{
				_vehicle = (vehicle _unit);
				
				_gunner = (gunner _vehicle);
				
				if ( (alive _gunner) && { (canFire _vehicle) } && { (someAmmo _vehicle) } ) then
				{
					_driver = (driver _vehicle);
					
					if (_unit == _driver) then
					{
						if (_vehicle in (TCL_Vehicle select 0) ) exitWith {};
						
						[_group, _logic, _vehicle] spawn (TCL_Vehicle_F select 1);
						
						// player sideChat format ["TCL_Vehicle_F > Vehicle > %1", _vehicle];
					};
				}
				else
				{
					[_unit] orderGetIn False; [_unit] allowGetIn False;
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_vehicle"];
	
	(TCL_Assign select 0) pushBack _vehicle;
	
	(TCL_Vehicle select 0) pushBack _vehicle;
	
	private _driver = (driver _vehicle);
	private _gunner = (gunner _vehicle);
	
	_vehicle forceSpeed 0;
	
	sleep 10;
	
	_vehicle forceSpeed -1;
	
	private _time = (time + 10);
	
	while { ( (_group in (TCL_Reinforcement select 0) ) && { (canFire _vehicle) } && { (someAmmo _vehicle) } && { (alive _driver) } && { (_driver in _vehicle) } && { (alive _gunner) } && { (_gunner in _vehicle) } ) } do
	{
		if (time > _time) then
		{
			private _units = (units _group);
			
			if (_units findIf { ( (isNull objectParent _x) && { (currentCommand _x isEqualTo "GET IN") } && { (assignedVehicle _x == _vehicle) } ) } > -1) exitWith
			{
				_time = (time + 10);
				
				[_group, _vehicle] spawn (TCL_Vehicle_F select 2);
			};
		};
		
		sleep 5;
	};
	
	if ( (_group in (TCL_Reinforcement select 0) ) && { (someAmmo _vehicle) } ) then
	{
		if (alive _driver) then
		{
			[_driver] orderGetIn False; [_driver] allowGetIn False;
			
			while { ( (alive _driver) && { (_driver in _vehicle) } ) } do
			{
				sleep 1;
			};
			
			if (alive _driver) then
			{
				_driver assignAsGunner _vehicle;
				
				[_driver] orderGetIn True; [_driver] allowGetIn True;
				
				sleep 30 + (random 50);
				
				_gunner = _driver;
			};
		};
		
		if (alive _gunner) then
		{
			sleep 30 + (random 50);
		};
		
		if (_group in (TCL_Reinforcement select 0) ) then
		{
			private _crew = (crew _vehicle);
			
			_crew orderGetIn False; _crew allowGetIn False;
			
			// player sideChat format ["TCL_Vehicle_F > Crew > %1 > %2", _group, _crew];
		};
	};
	
	TCL_DeleteAT(TCL_Vehicle,0,_vehicle);
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Vehicle
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_vehicle"];
	
	private _array = [];
	
	_array pushBack _vehicle;
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	if ( (isNull objectParent _leader) || (_leader in _vehicle) ) then
	{
		_array = _array;
	}
	else
	{
		_array pushBack (vehicle _leader);
	};
	
	// player sideChat format ["TCL_Vehicle_F > Stop > Group > %1", _group];
	
	{_x forceSpeed 0} count _array;
	
	sleep 10;
	
	{_x forceSpeed -1} count _array;
	
	if (isNull objectParent _leader)  then
	{
		_leader forceSpeed -1;
	};
	
	_units doFollow _leader;
	
	}
];