TCL_Waiting_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Waiting Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Waiting
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _return = False;
	
	private _units = (units _enemy);
	
	private _leader = (leader _group);
	
	// if ( ( { (_x distance _leader < 100) } count (units _enemy) > 0) || (_group in (TCL_Reinforcement select 2) ) ) then
	
	if ( (_units findIf { (_x distance _leader < 100) } > -1) || (_group in (TCL_Reinforcement select 2) ) ) then
	{
		_return = True;
	}
	else
	{
		private _groups = (_logic getVariable "TCL_Reinforcement");
		
		_groups = _groups - [_group];
		
		if (_groups isEqualTo [] ) then
		{
			private _time = (_group getVariable "TCL_Waiting");
			
			if (time > _time) then
			{
				_return = True;
			};
		}
		else
		{
			// if ( ( { ( ( (leader _x distance _enemy) < (_leader distance _enemy) ) || (_leader distance leader _x < 100) ) } count _groups > 0) ) then
			
			if (_groups findIf { ( ( (leader _x distance _enemy) < (_leader distance _enemy) ) || (leader _x distance _leader < 100) ) } > -1) then
			{
				_return = True;
			}
			else
			{
				// if (_groups findIf { (_x in (TCL_Reinforcement select 1) ) } > -1) then {_return = False};
				
				{if (_x in (TCL_Reinforcement select 1) ) then {_x = _x} else {_return = True} } count _groups;
			};
		};
	};
	
	_return
	
	}
];