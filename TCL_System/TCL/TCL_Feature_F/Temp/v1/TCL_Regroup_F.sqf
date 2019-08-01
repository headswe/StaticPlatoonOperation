TCL_Regroup_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Regroup Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic"];
	
	private _condition = (_group getVariable "TCL_AI" select 8);
	
	if (_condition) then
	{
		private _array = ( (TCL_Hold select 0) + (TCL_Defend select 0) + (TCL_Location select 0) );
		
		if (_group in _array) exitWith {};
		
		if ( { ( (alive _x) && (isNull objectParent _x) ) } count (units _group) < 3) then
		{
			private _groups = (_logic getVariable "TCL_Reinforcement");
			
			_groups = _groups - [_group];
			
			if (count _groups > 0) then
			{
				[_group, _logic, _groups] call (TCL_Regroup_F select 1);
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_groups"];
	
	private _alpha = _group;
	
	private _leader = (leader _alpha);
	
	if (_leader == vehicle _leader) then
	{
		private _rank = [_leader] call TCL_Rank_F;
		
		private "_bravo";
		
		private _count = 0;
		
		for "_count" from _count to (count _groups - 1) do
		{
			_bravo = (_groups select _count);
			
			if ( { ( (alive _x) && (_x == vehicle _x) && (_x distance _leader < 100) ) } count (units _bravo) >= { ( (alive _x) && (_x == vehicle _x) && (_x distance _leader < 100) ) } count (units _alpha) ) then
			{
				if ( [_alpha, _bravo] call (TCL_KnowsAbout_F select 3) ) then
				{
					if (_rank <= [leader _bravo] call TCL_Rank_F) then
					{
						["TCL_Position", _alpha] call (TCL_Marker_F select 0);
						
						// player sideChat format ["TCL_Join_F > Group > %1", _alpha];
						
						private _units = (units _alpha);
						
						_units join _bravo;
						
						{if (count assignedVehicleRole _x > 0) then { [_x] orderGetIn False; [_x] allowGetIn False} } forEach _units;
					};
				};
			};
		};
	};
	
	True
	
	}
];