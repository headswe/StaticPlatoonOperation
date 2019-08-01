TCL_Sneaking_F = [

	 //////////////////////////////////////////////////////////////////////////////
	/*  /--------------------------------------------------------------------------
	\   \ Sneaking Function #0
	 \   \-------------------------------------------------------------------------
	  \   \ By =\SNKMAN/=
	  /   /------------------------------------------------------------------------
	*//////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group"];
	
	private _return = False;
	
	private _units = (units _group);
	
	_knowsAbout = (_units findIf { ( (alive _x) && { (group _enemy knowsAbout vehicle _x > 0) } ) } );
	
	if (_group in (TCL_Sneaking select 0) ) then
	{
		if (_knowsAbout > -1) then
		{
			_return = True;
		};
	}
	else
	{
		if (_knowsAbout == -1) then
		{
			private _leader = (leader _group);
			
			if (_leader distance _enemy < 300) then
			{
				if ( (units _enemy findIf { (_group knowsAbout vehicle _x > 0) } > -1) || (_group in (TCL_Reinforcement select 1) ) ) then
				{
					if (isNull objectParent _leader) then
					{
						_return = True;
						
						{_x disableAI "AUTOCOMBAT"} count _units;
						
						_group setBehaviour "AWARE";
						_group setCombatMode "WHITE";
						
						(TCL_Sneaking select 0) pushBack _group;
						
						// player sideChat format ["TCL_Sneaking_F > Sneaking > %1", _group];
						
						{if (floor (random 100) < 50) then {_x setUnitPos "MIDDLE"} } count _units;
					};
				};
			};
		};
	};
	
	_return
	
	}
];