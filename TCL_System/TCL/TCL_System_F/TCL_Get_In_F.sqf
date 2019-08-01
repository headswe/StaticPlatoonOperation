TCL_Get_In_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Get In Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Get In
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	if (TCL_System select 4) then
	{
		private _leader = (leader _group);
		
		private _objects = [];
		
		{_objects append (synchronizedObjects _x) } forEach units _group;
		
		{if (vehicle _x isKindOf "Man") then {_objects = _objects - [_x] } } forEach _objects;
		
		if (count _this == 1) then
		{
			_leader setVariable ["TCL_Get_In", True];
		}
		else
		{
			private _vehicle = _this select 1;
			
			_leader setVariable ["TCL_Get_In", False];
			
			_objects deleteAt (_objects find _vehicle);
		};
		
		if (count _objects > 0) then
		{
			private _count = 0;
			
			for "_count" from _count to (count _objects - 1) do
			{
				_vehicle = (_objects select _count);
				
				if ( (alive _vehicle) && { (count (crew _vehicle) == 0) } && { ( { (_vehicle isKindOf _x) } count ["Car","Tank","Air","Ship","StaticWeapon"] > 0) } ) exitWith
				{
					private _units = (units _group);
					
					[_units, _leader, _vehicle] call (TCL_Get_In_F select 1);
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Get In Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Get In
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units","_leader","_vehicle"];
	
	private _turrets = [_vehicle] call (TCL_Get_In_F select 2);
	
	private _array = [];
	
	{if (vehicle _x isKindOf "Man") then {_array pushBack _x} } forEach _units;
	
	private ["_unit","_turret"];
	
	private _count = 0;
	
	for "_count" from _count to (count _array - 1) do
	{
		_unit = (_array select _count);
		
		if (_vehicle emptyPositions "Driver" > 0) then
		{
			_unit assignAsDriver _vehicle;
			_unit moveInDriver _vehicle;
		}
		else
		{
			if (_vehicle emptyPositions "Commander" > 0) then
			{
				_unit assignAsCommander _vehicle;
				_unit moveInCommander _vehicle;
			}
			else
			{
				if (count _turrets > 1) then
				{
					_turret = (_turrets select 0);
					
					_unit assignAsTurret [_vehicle, _turret];
					_unit moveInTurret [_vehicle, _turret];
					
					_turrets deleteAt (_turrets find _turret);
				}
				else
				{
					if (_vehicle emptyPositions "Gunner" > 0) then
					{
						_unit assignAsGunner _vehicle;
						_unit moveInGunner _vehicle;
					}
					else
					{
						if (_vehicle emptyPositions "Cargo" > 0) then
						{
							_unit assignAsCargo _vehicle;
							_unit moveInCargo _vehicle;
						}
						else
						{
							private _type = (_leader getVariable "TCL_Get_In");
							
							if (_type) then
							{
								[_leader, _vehicle] call (TCL_Get_In_F select 0);
							};
						};
					};
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Get In Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Get In
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle"];
	
	private _array = [];
	
	private _turrets = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "turrets");
	
	if (isClass _turrets) then
	{
		if (count _turrets > 0) then
		{
			private ["_index","_turret"];
			
			private _count = 0;
			
			for "_count" from _count to (count _turrets - 1) do
			{
				_index = _count;
				
				_array pushBack [_index];
				
				_turret = (_turrets select _count);
				
				if (count (_turret >> "turrets") > 0) then
				{
					_array = [_array, _index, _turret] call (TCL_Get_In_F select 3);
				};
			};
		};
	};
	
	_array
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Get In Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Get In
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_array","_index","_turret"];
	
	private _turrets = (_turret >> "turrets");
	
	private _count = 0;
	
	for "_count" from _count to (count _turrets - 1) do
	{
		_array pushBack [_index, _count];
	};
	
	_array
	
	}
];