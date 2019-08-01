#include "TCL_Macros.hpp"

TCL_Unassign_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Unassign Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _time = 0;
	
	private _count = 30;
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	private _vehicle = (vehicle _leader);
	
	private _position = (getPos _vehicle);
	
	// player sideChat format ["TCL_Unassign_F > Group > %1", _group];
	
	private _distance = [_group, _logic, _vehicle] call (TCL_Unassign_F select 1);
	
	private _assign = True;
	
	if (_group knowsAbout vehicle _enemy > 0) then
	{
		_assign = False;
	};
	
	if (_assign) then
	{
		if (assignedVehicle _leader isKindOf "LandVehicle") then
		{
			_assign = False;
			
			_position = (getPos assignedVehicle _leader);
			
			private _distance = (_leader distance _logic);
			
			_distance = (_distance / 3);
			
			_units = _units select { ( (isNull objectParent _x) && { (_x distance assignedVehicle _x < _distance) } ) };
			
			if (_leader in _units) then
			{
				if (_units findIf { (assignedVehicleRole _x select 0 == "Driver") } < 0) then {_leader assignAsDriver assignedVehicle _leader};
				
				[_units, _group, _vehicle] call (TCL_Assign_F select 1);
			};
		};
	};
	
	private ["_waypoint","_driver","_enemy"];
	
	while { ( (units _group findIf { (alive _x) } > -1) && { (_group in (TCL_Reinforcement select 0) ) } ) } do
	{
		_waypoint = (_group getVariable "TCL_Waypoint");
		
		if ( (units _enemy findIf { ( (alive _x) && { (_group knowsAbout vehicle _x > 0) } ) } > -1) || (units _group findIf { ( (alive _x) && { ( (_x distance2D _waypoint < _distance) || (_x distance2D _logic < _distance) ) } ) } > -1) ) exitWith
		{
			if (_count < 0) exitWith
			{
				[_group] call (TCL_Behaviour_F select 0);
				
				[_enemy, _group, _logic] spawn (TCL_Unassign_F select 0);
				
				// player sideChat format ["TCL_Unassign_F > Stuck > %1", _group];
			};
			
			[_enemy, _group, _logic] call (TCL_Unassign_F select 2);
		};
		
		_leader = (leader _group);
		
		_vehicle = (vehicle _leader);
		
		if (_assign) then
		{
			if (isNull objectParent _leader) then
			{
				if (_leader distance _waypoint > 300) then
				{
					if (time > _time) then
					{
						_units = (units _group);
						
						_assign = [_units, _group] call (TCL_Assign_F select 0);
						
						if (_assign) exitWith
						{
							_time = (time + 30);
						};
						
						_vehicle = (assignedVehicle _leader);
						
						_position = (getPos assignedVehicle _leader);
					};
				};
			};
		}
		else
		{
			_driver = (driver _vehicle);
			
			if (alive _driver) then
			{
				_count = [_group, _vehicle] call (TCL_Stuck_F select 0);
			};
		};
		
		_enemy = [_enemy, _group] call (TCL_Enemy_F select 0);
		
		sleep 1;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_vehicle"];
	
	private _distance = 100;
	
	private _random = (random _distance);
	
	_distance = (_distance + _random);
	
	if (_vehicle isKindOf "Helicopter") then
	{
		private _value = 0;
		
		private _crew = (crew _vehicle);
		
		if (_crew findIf { ( (assignedVehicleRole _x select 0 == "Cargo") && { (backpack _x isEqualTo "B_Parachute") } ) } > -1) then
		{
			_value = 50;
		};
		
		if (floor (random 100) < _value) then
		{
			_vehicle flyInHeight _distance;
			
			_group setVariable ["TCL_Eject", True];
		}
		else
		{
			_group setVariable ["TCL_Eject", False];
		};
		
		_random = 1 + (random 1);
		
		_distance = (_distance * _random);
	};
	
	// private _value = 1 + (random 1);
	
	// _distance = (_distance * _value);
	
	// player sideChat format ["TCL_Unassign_F > Distance > %1 > %2", _group, _distance];
	
	_distance
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _leader = (leader _group);
	
	private _vehicle = (vehicle _leader);
	
	// _group setVariable ["TCL_KnowsAbout", 0];
	
	if (_group in (TCL_Reinforcement select 1) ) then
	{
		TCL_DeleteAT(TCL_Reinforcement,1,_group);
		
		[_group] call (TCL_Behaviour_F select 0);
	};
	
	if (_group in (TCL_Reinforcement select 2) ) then
	{
		TCL_DeleteAT(TCL_Reinforcement,2,_group);
	};
	
	[_enemy, _group, _logic] call (TCL_Unassign_F select 3);
	
	if (True) then
	{
		private _units = (units _group);
		
		if (_vehicle isKindOf "Man") exitWith
		{
			if (_units findIf { (count assignedVehicleRole _x > 0) } > -1) then
			{
				[_group, _logic] call (TCL_Vehicle_F select 0);
			};
		};
		
		if (_vehicle isKindOf "Ship") exitWith
		{
			[_group, _logic, _vehicle] spawn (TCL_Ship_F select 0);
		};
		
		if (_vehicle isKindOf "Helicopter") exitWith
		{
			if (getPos _vehicle select 2 < 10) then
			{
				_vehicle land "LAND";	
				
				_units orderGetIn False; _units allowGetIn False;
			}
			else
			{
				if (_units findIf { ( (assignedVehicleRole _x select 0 == "Cargo") && (count (assignedVehicleRole _x) == 1) ) } > -1) then
				{
					[_group, _logic, _vehicle] spawn (TCL_Helicopter_F select 0);
				}
				else
				{
					_vehicle flyInHeight 50;
				};
			};
		};
		
		if (_vehicle isKindOf "LandVehicle") exitWith
		{
			private _driver = (driver _vehicle);
			
			if (alive _driver) then
			{
				[_group, _logic] call (TCL_Vehicle_F select 0);
			};
		};
	};
	
	// player sideChat format ["TCL_Unassign_F > Vehicle > %1 > %2", _vehicle, (assignedVehicle _leader) ];
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Unassign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	[_group, _logic] call (TCL_Reveal_F select 0);
	
	if (_group knowsAbout vehicle _enemy > 0) then
	{
		private _units = (units _group); 
		
		_units doWatch (getPos _enemy);
		
		_group setVariable ["TCL_KnowsAbout", 0];
		
		if ( [dayTime] call TCL_Daytime_F) then
		{
			private _leader = (leader _group);
			
			if (isNull objectParent _leader) then
			{
				[_enemy, _group] spawn (TCL_Smoke_F select 0);
				
				_units select { ( (alive assignedVehicle _x) && { (assignedVehicle _x isKindOf "LandVehicle") } && { (_x == driver assignedVehicle _x) } ) } apply { [_enemy, _group, assignedVehicle _x] spawn (TCL_Smoke_F select 1) };
			}
			else
			{
				private _vehicle = (vehicle _leader);
				
				if (_vehicle isKindOf "LandVehicle") then
				{
					[_enemy, _group, _vehicle] spawn (TCL_Smoke_F select 1);
				};
			};
		}
		else
		{
			[_enemy, _group, _logic] spawn (TCL_Flare_F select 0);
		};
		
		[_enemy, _group, _logic] call (TCL_Artillery_F select 0);
	};
	
	True
	
	}
];