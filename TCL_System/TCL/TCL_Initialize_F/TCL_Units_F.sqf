TCL_Units_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Units Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_units"];
	
	private ["_unit","_vehicle","_weapon","_ammo"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		_unit allowFleeing 0;
		
		_unit disableAI "TARGET";
		
		_vehicle = (vehicle _unit);
		
		if (_vehicle isKindOf "StaticWeapon") then
		{
			private _group = (group _unit);
			
			(TCL_Static_Weapon select 0) pushBack _unit;
			
			(TCL_Static_Weapon select 1) pushBack _vehicle;
			
			[_unit, _group, _vehicle] spawn (TCL_Static_Weapon_F select 3);
		};
		
		[_unit] call (TCL_Skill_F select 0);
		
		[_unit] call (TCL_Marker_F select 0);
		
		_unit setVariable ["TCL_Take_Cover", [time, [], (getPos _unit) ] ];
	};
	
	if (TCL_System select 3) then
	{
		(TCL_Players select 1) append _units;
	};
	
	True
	
	}
];