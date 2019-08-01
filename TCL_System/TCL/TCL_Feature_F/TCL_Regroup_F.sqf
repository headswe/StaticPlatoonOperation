TCL_Regroup_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_count"];
	
	private _ai = (_group getVariable "TCL_AI" select 9);
	
	if (_ai) then
	{
		private _array = ( (TCL_Hold select 0) + (TCL_Defend select 0) + (TCL_Location select 0) );
		
		if (_group in _array) exitWith {};
		
		if (_count < 3) then
		{
			if (True) then
			{
				if (floor (random 100) < 15) exitWith
				{
					// [_group] spawn (TCL_Surrender_F select 0);
				};
			};
			
			private _groups = (_logic getVariable "TCL_Reinforcement");
			
			_groups = _groups - [_group];
			
			_groups = _groups select { (side _group isEqualTo side _x) };
			
			if (_groups isEqualTo [] ) exitWith {};
			
			[_group, _logic, _count, _groups] call (TCL_Regroup_F select 1);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Regroup
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_count","_groups"];
	
	private _leader = (leader _group);
	
	if (isNull objectParent _leader) then
	{
		private "_units";
		
		private _rank = [_leader] call TCL_Rank_F;
		
		private _condition = {_this select { ( (alive _x) && { (isNull objectParent _x) } && { (_x distance _leader < 100) } ) }; count _this};
		
		{_units = (units _x);
		
		if ( (_count <= _units call _condition) && { (_rank <= [leader _x] call TCL_Rank_F) } && { ( [_group, _x] call (TCL_KnowsAbout_F select 4) ) } ) exitWith
		{
			_units = (units _group);
			
			["TCL_Position", _group] call (TCL_Marker_F select 0);
			
			// player sideChat format ["TCL_Regroup_F > Group > %1", _group];
			
			_groups = (_logic getVariable "TCL_Reinforcement");
			
			_groups deleteAt (_groups find _group);
			
			_units join _x;
			
			(TCL_Regroup select 0) append _units;
			
			_units select { (count assignedVehicleRole _x > 0) } apply { [_x] orderGetIn False; [_x] allowGetIn False};
			
			_units select { ( (fleeing _x) || (captive _x) ) } apply {if (fleeing _x) then {_x allowFleeing 0} else {_x setCaptive False} };
		};
		
		} count _groups;
	};
	
	True
	
	}
];