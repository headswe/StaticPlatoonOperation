TCL_Remount_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	{_x setUnitPos "AUTO"} count _units;
	
	_group setVariable ["TCL_Enemy", objNull];
	
	if (isNil { (_group getVariable "TCL_Helicopter") } ) then
	{
		_leader = _leader;
	}
	else
	{
		_leader = (_group getVariable "TCL_Helicopter");
		
		if (alive _leader) then
		{
			_group selectLeader _leader;
		}
		else
		{
			_leader = (leader _group);
		};
	};
	
	private _vehicle = (assignedVehicle _leader);
	
	if ( (alive _vehicle) && { (canMove _vehicle) } ) then
	{
		_vehicle = _vehicle;
	}
	else
	{
		_vehicle = (vehicle _leader);
	};
	
	// player sideChat format ["TCL_Remount_F > Vehicle > %1", _vehicle];
	
	[_group, _vehicle] call (TCL_Remount_F select 1);
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_vehicle"];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	private _position = (_group getVariable "TCL_Position");
	
	["TCL_Remount", _group] call (TCL_Marker_F select 0);
	
	if (_leader in (TCL_Static_Weapon select 0) ) then
	{
	
	}
	else
	{
		_units select { (_x in (TCL_Static_Weapon select 0) ) } apply {_x leaveVehicle assignedVehicle _x; [_x] orderGetIn False; [_x] allowGetIn False};
		
		// {if (_x in (TCL_Static_Weapon select 0) ) then {_x leaveVehicle assignedVehicle _x; [_x] orderGetIn False; [_x] allowGetIn False} } forEach _units;
	};
	
	if (True) then
	{
		if (_vehicle isKindOf "Ship") exitWith
		{
			[_group] call (TCL_Remount_F select 2);
		};
		
		if (_vehicle isKindOf "Helicopter") exitWith
		{
			private _crew = (crew _vehicle);
			
			if (_crew findIf { (alive _x) } > -1) then
			{
				[_group, _crew, _vehicle] spawn (TCL_Helicopter_F select 1);
			};
			
			TCL_Helicopter set [0, (TCL_Helicopter select 0) - _crew];
		};
		
		if (_vehicle isKindOf "LandVehicle") exitWith
		{
			[_group] call (TCL_Remount_F select 2);
			
			// player sideChat format ["TCL_Remount_F > Vehicle > %1", (typeOf _vehicle) ];
		};
	};
	
	_group lockWp False;
	
	_group move _position;
	
	_units doFollow _leader;
	
	[_group] call (TCL_Remount_F select 4);
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _vehicles = [];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	(TCL_Remount select 0) pushBack _group;
	
	private ["_unit","_vehicle"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		_vehicle = (assignedVehicle _unit);
		
		if (_vehicle in _vehicles) then
		{
			_vehicle = _vehicle;
		}
		else
		{
			if (_unit in _vehicle) then
			{
				_unit = _unit;
			}
			else
			{
				_vehicles pushBack _vehicle;
				
				TCL_Assign set [0, (TCL_Assign select 0) - [_vehicle] ];
				
				["TCL_Remount", _group, _vehicle] call (TCL_Marker_F select 0);
			};
		};
	};
	
	_units orderGetIn True; _units allowGetIn True;	
	
	[_group, _vehicles] spawn (TCL_Remount_F select 3);
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_vehicles"];
	
	private _units = (units _group);
	
	{_x forceSpeed 0} count _vehicles;
	
	while { (count _units > 0) } do
	{
		// player sideChat format ["TCL_Remount_F > Units > %1", _units];
		
		_units = _units select { ( (alive _x) && { (isNull objectParent _x) } && { (count assignedVehicleRole _x > 0) } && { (assignedVehicle _x in _vehicles) } && { (_x in units _group) } ) };
		
		if (_group in (TCL_Reinforcement select 0) ) exitWith
		{
			{if (_x distance assignedVehicle _x > 100) then { [_x] orderGetIn False; [_x] allowGetIn False} } count _units;
		};
		
		sleep 5;
	};
	
	{_x forceSpeed -1} count _vehicles;
	
	TCL_Remount set [0, (TCL_Remount select 0) - [_group] ];
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #4
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _array = (_group getVariable "TCL_Behaviour");
	
	_group setBehaviour (_array select 0);
	
	_group setCombatMode (_array select 1);
	
	_group setFormation (_array select 2);
	
	_group setSpeedMode (_array select 3);
	
	[_group] spawn (TCL_Remount_F select 5);
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Remount Function #5
	// ////////////////////////////////////////////////////////////////////////////
	// Remount
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	if (_group in (TCL_Garrison select 2) ) then
	{
		private _bool = True;
		
		private _leader = (leader _group);
		
		private _position = (_group getVariable "TCL_Position");
		
		private _distance = (_leader distance _position);
		
		private _time = (time + 30);
		
		_time = (_time + _distance);
		
		while { (_leader distance _position > 10) } do
		{
			if ( (time > _time) || (_group in (TCL_Reinforcement select 0) ) ) exitWith
			{
				_bool = False;
			};
			
			sleep 10;
		};
		
		if (_bool) then
		{
			private _units = (units _group);
			
			if (vehicle _leader isKindOf "Car") then
			{
				{ [_x] orderGetIn False; [_x] allowGetIn False} count _units;
				
				sleep 10;
			};
			
			[_group] spawn (TCL_Garrison_F select 0);
		};
	};
	
	}
];