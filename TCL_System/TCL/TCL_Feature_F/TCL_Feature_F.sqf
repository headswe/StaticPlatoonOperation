TCL_Feature_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Feature Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Feature
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_units"];
	
	_units = _units - ( (TCL_Heal select 1) + (TCL_Rearm select 1) );
	
	private "_unit";
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (TCL_Feature select 30) then
		{
			if (floor (random 100) < (TCL_Feature select 31) ) then
			{
				[_unit, _group] call (TCL_Heal_F select 0);
			};
		};
		
		if (TCL_Feature select 32) then
		{
			if (floor (random 100) < (TCL_Feature select 33) ) then
			{
				if (_unit in (TCL_Heal select 0) ) exitWith {};
				
				[_unit, _group] call (TCL_Rearm_F select 0);
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Feature Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Feature
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic","_array","_knowsAbout"];
	
	if (_knowsAbout > 0) then
	{
		private _units = (units _group);
		
		// if (_array isEqualTo _units) exitWith {};
		
		_array = [_enemy, _units, _group, _logic, _array] call TCL_Visible_F;
		
		// player sideChat format ["TCL_Feature_F > Visible > %1", _array];
	};
	
	if (_array isEqualTo [] ) then
	{
		if (TCL_Feature select 11) then
		{
			if (floor (random 100) < (TCL_Feature select 12) ) then
			{
				private _leader = (leader _group);
				
				if (_leader distance _logic < 100) then
				{
					[_enemy, _group, _logic] call (TCL_House_Search_F select 0);
					
					// player sideChat format ["TCL_Feature_F > House Search > %1", _group];
				};
			};
		};
	}
	else
	{
		if (_knowsAbout > 0) then
		{
			if (TCL_Feature select 13) then
			{
				if (floor (random 100) < (TCL_Feature select 14) ) then
				{
					[_enemy, _group, _logic] call (TCL_Static_Weapon_F select 0);
					
					// player sideChat format ["TCL_Feture_F > Static Weapon > %1 > %2", _group];
				};
			};
			
			if (TCL_Feature select 15) then
			{
				[_enemy, _group, _array] call (TCL_Take_Cover_F select 0);
				
				// player sideChat format ["TCL_Feture_F > Take Cover > %1 > %2", _group, (count _array) ];
			};
		};
	};
	
	_array
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Feature Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Feature
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_object","_array","_distance"];
	
	private _groups = (TCL_Groups select 0);
	
	_groups = _groups - _array;
	
	private ["_group","_leader"];
	
	private _count = 0;
	
	for "_count" from _count to (count _groups - 1) do
	{
		_group = (_groups select _count);
		
		_leader = (leader _group);
		
		if (isNull objectParent _leader) then
		{
			[_object, _group, _distance] call (TCL_Advancing_F select 1);
		};
	};
	
	True
	
	}
];