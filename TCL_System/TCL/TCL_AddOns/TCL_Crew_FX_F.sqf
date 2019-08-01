TCL_Crew_FX_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Crew FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Crew FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_crew","_vehicle"];
	
	private _driver = (driver _vehicle);
	
	private _side = (side _driver);
	
	private _group = createGroup _side;
	
	while { (getPos _vehicle select 2 > 3) } do
	{
		sleep 1;
	};
	
	private ["_unit","_type","_spawn"];
	
	while { (count _crew > 0) } do
	{
		_unit = (_crew select 0);
		
		if (floor (random 100) < 35) then
		{
			_type = (typeOf _unit);
			
			_spawn = _group createUnit [_type, [ (getPos _unit select 0), (getPos _unit select 1), - 5], [], 0, "CAN_COLLIDE"];
			
			_spawn setDammage (random 0.3);
			
			_spawn allowDamage False;
			
			[_spawn, _vehicle] spawn (TCL_Crew_FX_F select 1);
			
			// _type createUnit [ [ (getPos _unit select 0), (getPos _unit select 1), - 5], _group, "if (TCL_Multiplayer) then {if (isServer) then {this allowDamage False; [this, _vehicle] spawn (TCL_Crew_FX_F select 1) } else { [this] spawn (TCL_Fire_FX_F select 0) } } else {this allowDamage False; [this, _vehicle] spawn (TCL_Crew_FX_F select 1) }"];
		};
		
		_crew deleteAt (_crew find _unit);
		
		deleteVehicle _unit;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Crew Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Crew FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_vehicle"];
	
	[_unit] join grpNull;
	
	private _group = (group _unit);
	
	(TCL_Disabled select 0) pushBack _group;
	
	removeAllWeapons _unit;
	
	_unit allowFleeing 0;
	
	_unit setCaptive True;
	
	_unit setUnitPos "UP";
	
	_unit setSpeedMode "FULL";
	
	_unit setCombatMode "BLUE";
	
	_unit disableAI "AUTOCOMBAT";
	
	_unit setBehaviour "CARELESS";
	
	sleep 10 + (random 30);
	
	if (TCL_Multiplayer) then
	{
		TCL_Public = [_unit];
		
		publicVariable "TCL_Public";
		
		if (TCL_Dedicated) exitWith {};
		
		[_unit] spawn (TCL_Fire_FX_F select 0);
	}
	else
	{
		[_unit] spawn (TCL_Fire_FX_F select 0);
	};
	
	_unit setDir (random 360);
	
	_unit setPos (getPos _vehicle);
	
	_unit allowDamage True;
	
	private _array = ["AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDr","AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDl"];
	
	while { (alive _unit) } do
	{
		_unit doMove [ ( (getPos _unit select 0) + (random 100 - random 100) ), ( (getPos _unit select 1) + (random 100 - random 100) ), 0];
		
		if (floor (random 100) < 35) then
		{
			if (_unit distance _vehicle > 5) then
			{
				if (animationState _unit in _array) exitWith {};
				
				if (floor (random 100) < 50) then
				{
					_unit playMove "AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDr";
				}
				else
				{
					_unit playMove "AmovPpneMstpSnonWnonDnon_AmovPpneMevaSnonWnonDl";
				};
			};
		};
		
		_unit setDamage (damage _unit + random 0.1);
		
		if (damage _unit > 0.5) then
		{
			_unit setDamage 1;
		};
		
		sleep 5;
	};
	
	}
];