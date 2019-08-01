TCL_Assign_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Assign Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Assign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units","_group"];
	
	private _return = True;
	
	if (_units isEqualTo [] ) exitWith {_return = False};
	
	private _unit = (_units select 0);
	
	if (isNull objectParent _unit) then
	{
		private _objects = _unit nearEntities ["Car", 100];
		
		private _array = ( (TCL_Assign select 0) + (TCL_Stuck select 0) );
		
		_objects = _objects - _array;
		
		_objects = _objects select { ( (alive _x) && { (fuel _x > 0) } && { (canMove _x) } && { (_unit knowsAbout _x > 0) } ) };
		
		if (_objects isEqualTo [] ) exitWith {};
		
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
				_return = False;
				
				(TCL_Assign select 0) pushBack _vehicle;
				
				[_units, _group, _vehicle] call (TCL_Assign_F select 1);
			};
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Assign Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Assign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units","_group","_vehicle"];
	
	private _leader = (leader _group);
	
	if (_group in (TCL_Artillery select 0) ) exitWith {};
	
	// player sideChat format ["TCL_Assign_F > Vehicle > %1", _vehicle];
	
	_units select { (_x in (TCL_Static_Weapon select 0) ) } apply {_x leaveVehicle assignedVehicle _x; [_x] orderGetIn False; [_x] allowGetIn False};
	
	{if (_x in assignedVehicle _x) then {_units = _units - [_x] } else {if (count assignedVehicleRole _x > 0) then {_units = _units - [_x]; [_x] orderGetIn True; [_x] allowGetIn True} } } count _units;
	
	if (_units isEqualTo [] ) exitWith {True};
	
	_units = [_units, _vehicle] call (TCL_Assign_F select 2);
	
	if (_units isEqualTo [] ) exitWith {True};
	
	{_x assignAsCargo _vehicle} count _units;
	
	{if (assignedVehicle _x == _vehicle) then {_units = _units - [_x]; [_x] orderGetIn True; [_x] allowGetIn True} } count _units;
	
	if (_units isEqualTo [] ) exitWith {True};
	
	[_units, _group, _vehicle] call (TCL_Assign_F select 0);
	
	// player sideChat format ["TCL_Assign_F > Units > %1", _units];
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Assign Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Assign
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units","_vehicle"];
	
	private _positions = ["Driver","Gunner","Commander"];
	
	private ["_position","_unit"];
	
	while { (count _positions > 0) } do
	{
		_position = (_positions select 0);
		
		if (_units isEqualTo [] ) exitWith {};
		
		// player sideChat format ["TCL_Assign_F > Positions > %1", _positions];
		
		if (_vehicle emptyPositions _position > 0) then
		{
			_unit = (_units select 0);
			
			if (alive _unit) then
			{
				if (_position isEqualTo "Driver") exitWith
				{
					_unit assignAsDriver _vehicle;
				};
				
				if (_position isEqualTo "Gunner") exitWith
				{
					_unit assignAsGunner _vehicle;
				};
				
				if (_position isEqualTo "Commander") exitWith
				{
					_unit assignAsCommander _vehicle;
				};
			};
			
			_units deleteAt (_units find _unit);
			
			[_unit] orderGetIn True; [_unit] allowGetIn True;
			
			// player sideChat format ["TCL_Assign_F > Position > %1 > %2", _unit, _position];
		};
		
		_positions deleteAt (_positions find _position);
	};
	
	_units
	
	}
];