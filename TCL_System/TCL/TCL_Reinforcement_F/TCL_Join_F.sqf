TCL_Join_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Join Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Join
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_units"];
	
	private _ai = (_group getVariable "TCL_AI" select 8);
	
	if (_ai) then
	{
		private _array = ( (TCL_Hold select 0) + (TCL_Defend select 0) + (TCL_Location select 0) );
		
		if (_group in _array) exitWith {};
		
		if (_units < 3) then
		{
			private _groups = (_logic getVariable "TCL_Reinforcement");
			
			_groups = _groups - [_group];
			
			_groups = _groups select { (side _group isEqualTo side _x) };
			
			if (_groups isEqualTo [] ) exitWith {};
			
			[_group, _logic, _units, _groups] call (TCL_Join_F select 1);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Join Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Join
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_units","_groups"];
	
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
			
			_condition = (units _bravo) select { ( (alive _x) && { (isNull objectParent _x) } && { (_x distance _leader < 100) } ) };
			
			if ( (_units <= count _condition) && { (_rank <= [leader _bravo] call TCL_Rank_F) } && { ( [_alpha, _bravo] call (TCL_KnowsAbout_F select 4) ) } ) exitWith
			{
				private _units = (units _alpha);
				
				["TCL_Position", _alpha] call (TCL_Marker_F select 0);
				
				// player sideChat format ["TCL_Join_F > Group > %1", _alpha];
				
				_groups = (_logic getVariable "TCL_Reinforcement");
				
				_groups deleteAt (_groups find _alpha);
				
				_units join _bravo;
				
				(TCL_Regroup select 0) append _units;
				
				_units select { (count assignedVehicleRole _x > 0) } apply { [_x] orderGetIn False; [_x] allowGetIn False};
			};
		};
	};
	
	True
	
	}
];