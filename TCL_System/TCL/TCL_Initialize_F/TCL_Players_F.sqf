TCL_Players_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Players Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_players"];
	
	(TCL_Players select 0) append _players;
	
	private ["_player","_group","_leader"];
	
	private _count = 0;
	
	for "_count" from _count to (count _players - 1) do
	{
		_player = (_players select _count);
		
		_group = (group _player);
		
		_leader = (leader _group);
		
		[_player] call (TCL_Marker_F select 0);
		
		if (_player == _leader) then
		{
			(TCL_Players select 2) pushBackUnique _group;
			
			{ [_x] call (TCL_Marker_F select 0) } forEach units _player;
		};
		
		_player setVariable ["TCL_Suppressed", time];
		
		if (TCL_Dedicated) then
		{
			_player addEventHandler ["FiredMan", {_this call (TCL_EH_Fired_F select 0) } ];
		};
	};
	
	if (TCL_System select 3) then
	{
		(TCL_Players select 1) append _players;
	};
	
	True
	
	}
];