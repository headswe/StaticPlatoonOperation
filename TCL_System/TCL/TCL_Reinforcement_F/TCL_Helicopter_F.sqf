TCL_Helicopter_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Helicopter Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_vehicle"];
	
	private _array = [];
	
	private _bool = False;
	
	private _cargo = True;
	
	private _units = (units _group);
	
	if (_group getVariable "TCL_Eject") then
	{
		private "_unit";
		
		private _count = 0;
		
		for "_count" from _count to (count _units - 1) do
		{
			_unit = (_units select _count);
			
			if (assignedVehicleRole _unit select 0 == "Cargo") then
			{
				_array pushBack _unit;
				
				if (backpack _unit isEqualTo "B_Parachute") then
				{
					_unit action ["EJECT", _vehicle];
					
					_unit allowDamage False;
					
					_array pushBack _unit;
					
					sleep 1 - (random 1);
				}
				else
				{
					_bool = True;
				};
				
				[_unit] orderGetIn False; [_unit] allowGetIn False;
			};
		};
	}
	else
	{
		_bool = True;
		
		_units select { (assignedVehicleRole _x select 0 == "Cargo") } apply {if ( (floor (random 100) < 35) && { (count (assignedVehicleRole _x) > 1) } ) then {_cargo = False} else {_array pushBack _x; [_x] orderGetIn False; [_x] allowGetIn False} };
	};
	
	private _crew = (crew _vehicle);
	
	_crew = _crew - _array;
	
	if (_bool) then
	{
		_vehicle flyInHeight 100;
		
		_vehicle land "GET OUT";
	};
	
	if (count _array > 0) then
	{
		while { (_array findIf { (_x in _vehicle) } > -1) } do
		{
			sleep 5;
		};
		
		{_x allowDamage True} count _array;
		
		private _leader = (leader _group);
		
		if (_leader in _array) then
		{
			_group setVariable ["TCL_Helicopter", (driver _vehicle) ];
		}
		else
		{
			_group setVariable ["TCL_Helicopter", _leader];
			
			_leader = (_array select 0);
			
			_group selectLeader _leader;
			
			{_x setUnitRank "PRIVATE"} count _crew;
			
			_array select { (rank _x isEqualTo "PRIVATE") } apply {_x setUnitRank "CORPORAL"};
		};
	};
	
	private _random = 75;
	
	private _driver = (driver _vehicle);
	
	private _gunner = (gunner _vehicle);
	
	if ( (alive _gunner) && { (canFire _vehicle) } && { (someAmmo _vehicle) } ) then
	{
		_random = 50;
	};
	
	_vehicle flyInHeight 100;
	
	if ( (alive _logic) && { (_cargo) } && { (floor (random 100) < _random) } ) then
	{
		private _crew = (crew _vehicle);
		
		(TCL_Helicopter select 0) append _crew;
		
		_position = (_group getVariable "TCL_Position");
		
		sleep 5 + (random 10);
		
		_driver doMove _position;
		
		private _land = "Land_HelipadEmpty_F" createVehicleLocal _position;
		
		while { ( (alive _vehicle) && { (_vehicle distance2D _position > 100) } ) } do
		{
			sleep 1;
		};
		
		if (alive _logic) then
		{
			_vehicle land "LAND";
			
			{doStop _x} count _crew;
			
			while { (getPos _vehicle select 2 > 10) } do
			{
				sleep 1;
			};
		};
		
		deleteVehicle _land;
	}
	else
	{
		_vehicle flyInHeight 50;
		
		if (floor (random 100) < 50) then
		{
			_group selectLeader _driver;
		};
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Helicopter Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_crew","_vehicle"];
	
	_vehicle forceSpeed -1;
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	private _driver = (driver _vehicle);
	
	private _position = (_group getVariable "TCL_Position");
	
	_units = _units - _crew;
	
	if (_units findIf { (alive _x) } > -1) then
	{
		private _unit = (_units select 0);
		
		{if (_x == _leader) exitWith {_unit = _x} } count _units;
		
		_driver doMove (getPos _unit);
		
		while { (_vehicle distance2D _unit > 100) } do
		{
			sleep 1;
		};
		
		if (floor (random 100) < 50) then
		{
			_vehicle land "LAND";
		}
		else
		{
			_vehicle land "GET IN";
		};
	};
	
	_group move _position;
	
	[_group] call (TCL_Remount_F select 2);
	
	while { ( (alive _vehicle) && { (_vehicle distance2D _position > 100) } ) } do
	{
		sleep 1;
	};
	
	_vehicle land "LAND";
	
	}
];