TCL_KnowsAbout_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _units = (TCL_Players select 0);
	
	if (TCL_System select 3) then
	{
		_units = (TCL_Players select 1);
	};
	
	_units = _units select { ( (alive _x) && { (_group knowsAbout vehicle _x > 0) } && { (side _group getFriend side _x < 0.6) } ) };
	
	private "_unit";
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if ( [_unit, _group] call (TCL_KnowsAbout_F select 1) ) exitWith
		{
			private _enemy = _unit;
			
			private _logic = [_enemy] call (TCL_Logic_F select 0);
			
			(TCL_Logic select 0) pushBack _logic;
			
			_logic setVariable ["TCL_Group", (group _enemy) ];
			
			_logic setVariable ["TCL_Units", (units _enemy) ];
			
			["TCL_Logic", _logic] call (TCL_Marker_F select 0);
			
			_logic setVariable ["TCL_Artillery", [True, False] ];
			
			[_enemy, _group, _logic] call (TCL_Reinforcement_F select 0);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group"];
	
	if (_group in (TCL_Reinforcement select 0) ) exitWith {_return = False};
	
	private _return = True;
	
	private _array = (TCL_Logic select 0);
	
	private _ai = (_group getVariable "TCL_AI");
	
	private "_logic";
	
	private _count = 0;
	
	for "_count" from _count to (count _array - 1) do
	{
		_logic = (_array select _count);
		
		if ( [_enemy, _group, _logic] call (TCL_KnowsAbout_F select 2) ) exitWith
		{
			_return = False;
			
			if (_ai select 3) then
			{
				_return = True;
			}
			else
			{
				private _bool = False;
				
				if (_group knowsAbout vehicle _enemy > (_ai select 4) ) then
				{
					_bool = True;
				}
				else
				{
					private _leader = (leader _group);
					
					if (_leader distance _logic < (_ai select 5) ) then
					{
						_bool = True;
					};
				};
				
				if (_bool) then
				{
					if (_ai select 6) then
					{
						(TCL_Join select 0) pushBack _group;
					};
					
					[_enemy, _group, _logic] call (TCL_Reinforcement_F select 0);
				};
			};
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _return = False;
	
	private _groups = (_logic getVariable "TCL_Reinforcement");
	
	if (_groups findIf { (side _group getFriend side _x < 0.6) } > -1) exitWith {_return};
	
	if ( (group _enemy) isEqualTo (_logic getVariable "TCL_Group") ) then
	{
		_return = True;
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout
	// By =\SNKMAN/=
	// Used: TCL_System.fsm
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _time = (TCL_Radio select 1);
	
	private _random = (random _time);
	
	_time = (_time + _random);
	
	_skill = [_group] call TCL_Accuracy_F;
	
	_time = (_time / _skill);
	
	// player sideChat format ["TCL_KnowsAbout_F > Time > %1 > %2 > %3", _group, _skill, (round _time) ];
	
	_time = (time + _time);
	
	private _return = _time;
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout Function #4
	// ////////////////////////////////////////////////////////////////////////////
	// KnowsAbout
	// By =\SNKMAN/=
	// Used: Join Function #1 Reveal Function #1
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_echo","_kilo"];
	
	private _return = False;
	
	private _units = (units _kilo);
	
	private _value = (TCL_IQ select 0);
	
	private _knowsAbout = (_units findIf { ( (alive _x) && { (_echo knowsAbout vehicle _x > _value) } ) } );
	
	if (_knowsAbout == -1) then
	{
		_units = (units _echo);
		
		_knowsAbout = (_units findIf { ( (alive _x) && { (_kilo knowsAbout vehicle _x > _value) } ) } );
	};
	
	if (_knowsAbout > -1) then
	{
		_return = True;
	};
	
	// player sideChat format ["TCL_KnowsAbout_F > KnowsAbout > %1 > %2", _echo, _knowsAbout];
	
	_return
	
	}
];