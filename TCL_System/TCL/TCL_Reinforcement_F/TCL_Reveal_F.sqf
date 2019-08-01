TCL_Reveal_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Reveal Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Reveal
	// By =\SNKMAN/=
	// Used: Unassign Function #3
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic"];
	
	private _units = (units _group);
	
	private _skill = [_group] call TCL_Accuracy_F;
	
	private _groups = (_logic getVariable "TCL_Reinforcement");
	
	// player sideChat format ["TCL_Reveal_F > TCL_Unassign_F > %1", _groups];
	
	_groups = _groups - [_group];
	
	private ["_enemy","_bool","_knowsAbout","_knowledge","_random"];
	
	{_enemy = (_x getVariable "TCL_Enemy");
	
	_bool = [_group, _x] call (TCL_Radio_F select 0);
	
	if ( (alive _enemy) && { (_bool) } ) then
	{
		_knowsAbout = (_x knowsAbout vehicle _enemy);
		
		if (_knowsAbout > (_group knowsAbout vehicle _enemy) ) then
		{
			_bool = [_group, _x] call (TCL_KnowsAbout_F select 4);
			
			if (_bool) then
			{
				_knowledge = (_group knowsAbout vehicle _enemy);
				
				_random = (random _knowsAbout);
				
				_random = (_random * _skill);
				
				_knowledge = (_knowledge + _random);
				
				_group reveal [_enemy, _knowledge];
				
				// player sideChat format ["TCL_Reveal_F > Unassign > Reveal > %1 > %2", _x, _group];
			}
			else
			{
				_units doWatch (getPos _enemy);
				
				// player sideChat format ["TCL_Reveal_F > Unassign > Watch > %1 > %2", _x, _group];
			};
			
			// player sideChat format ["TCL_Reveal_F > Unassign > %1 > %2 > %3 > %4", _enemy, _x, _group, _knowsAbout];
		};
	};
	
	} count _groups;
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reveal Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Reveal
	// By =\SNKMAN/=
	// Used: TCL_System.fsm
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _groups = (TCL_Groups select 0);
	
	private _skill = [_group] call TCL_Accuracy_F;
	
	_groups = _groups - (TCL_Reinforcement select 0);
	
	_groups = _groups select { (side _group getFriend side _x > 0.6) };
	
	if (_groups isEqualTo [] ) exitWith {True};
	
	private _value = (TCL_IQ select 0);
	
	private _distance = (TCL_IQ select 1);
	
	private _knowsAbout = (_group knowsAbout vehicle _enemy);
	
	private ["_leader","_bool","_units","_random"];
	
	{_leader = (leader _x);
	
	_bool = [_group, _x, _distance] call (TCL_Reveal_F select 2);
	
	if ( (isNull objectParent _leader) && { (_bool) } ) exitWith
	{
		_units = (units _x);
		
		_random = (random _knowsAbout);
		
		// _random = (_random / _skill);
		
		if (_random > _value) then
		{
			_x reveal [_enemy, _random];
			
			// player sideChat format ["TCL_Reveal_F > Communicate > Reveal > %1 > %2 > %3", _enemy, _group, _x];
		}
		else
		{
			_units doWatch (getPos _enemy);
			
			// player sideChat format ["TCL_Reveal_F > Communicate > Watch > %1 > %2 > %3", _enemy, _group, _x];
		};
		
		// player sideChat format ["TCL_Reveal_F > Enemy > %1 > %2 > %3 > %4", _enemy, _group, _x, _random];
	};
	
	} count _groups;
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reveal Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Reveal
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_x","_distance"];
	
	private _return = False;
	
	private _units = (units _group);
	
	private ["_unit","_bool"];
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if ( (alive _unit) && { (units _x findIf { ( (alive _x) && { (_unit distance _x < _distance) } ) } > -1) } ) exitWith
		{
			_bool = [_group, _x] call (TCL_KnowsAbout_F select 4);
			
			if (_bool) then
			{
				_return = True;
			};
		};
	};
	
	_return
	
	}
];