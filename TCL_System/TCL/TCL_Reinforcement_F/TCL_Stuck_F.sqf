TCL_Stuck_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Stuck Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Stuck
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_vehicle"];
	
	private _leader = (leader _group);
	
	if (_leader in assignedVehicle _leader) then
	{
		private _driver = (driver _vehicle);
		
		if (alive _driver) then
		{
		
		}
		else
		{
			[_leader] orderGetIn False;
			
			_leader assignAsDriver _vehicle;
			
			[_leader] orderGetIn True;
		};
		
		private _units = (units _group);
		
		if (_count == 0) then
		{
			if (_units findIf { (currentCommand _x isEqualTo "GET IN") } > -1) then
			{
				_count = 30;
				
				// player sideChat format ["TCL_Stuck_F > Get In > %1", _group];
			}
			else
			{
				if (_vehicle distance _position > 3) then
				{
					_count = 30;
					
					_position = (getPos _vehicle);
					
					// player sideChat format ["TCL_Stuck_F > Moving > %1", _group];
				}
				else
				{
					if (_vehicle in (TCL_Stuck select 0) ) then
					{
						_count = _count - 1;
						
						_group leaveVehicle _vehicle;
						
						// player sideChat format ["TCL_Stuck_F > Stuck > %1", _group];
					}
					else
					{
						_count = 30;
						
						(TCL_Stuck select 0) pushBack _vehicle;
					};
				};
			};
		}
		else
		{
			private _array = [5,15,25];
			
			if (_count in _array) then
			{
				// _return = _units findIf { ( (_x == vehicle _x) && { (currentCommand _x isEqualTo "GET IN") } && { (_x distance assignedVehicle _x < 100) } ) };
				
				{if ( (isNull objectParent _x) && { (currentCommand _x isEqualTo "GET IN") } && { (_x distance assignedVehicle _x < 100) } ) exitWith { [_group, assignedVehicle _x] spawn (TCL_Vehicle_F select 2) } } count _units;
			};
			
			_count = _count - 1;
		};
		
		// player sideChat format ["TCL_Stuck_F > Count > %1 > %2", _group, _count];
	};
	
	_count
	
	}
];