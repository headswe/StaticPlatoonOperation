TCL_Radio_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Radio Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Radio
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_x"];
	
	private _return = True;
	
	if (TCL_Radio select 0) then
	{
		_return = False;
		
		private _bool = [_group] call (TCL_Radio_F select 1);
		
		if (_bool) then
		{
			private _leader = (leader _group);
			
			private _distance = [_group] call (TCL_Radio_F select 2);
			
			if (_leader distance leader _x < _distance) then
			{
				_bool = [_x] call (TCL_Radio_F select 1);
				
				if (_bool) then
				{
					_leader = (leader _x);
					
					_distance = [_x] call (TCL_Radio_F select 2);
					
					if (_leader distance leader _group < _distance) then
					{
						_return = True;
					};
				};
			};
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Radio Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Radio
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _return = False;
	
	private _units = (units _group);
	
	if (_units findIf { ( (alive _x) && ( ("ItemRadio" in items _x) || ("ItemRadio" in assigneditems _x) ) ) } > -1) then {_return = True};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Radio Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Radio
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _vehicle = (vehicle leader _group);
	
	private "_index";
	
	if (True) then
	{
		if (_vehicle isKindOf "Man") exitWith
		{
			_index = 0;
		};
		
		if (_vehicle isKindOf "Car") exitWith
		{
			_index = 1;
		};
		
		if (_vehicle isKindOf "Tank") exitWith
		{
			_index = 2;
		};
		
		if (_vehicle isKindOf "Air") exitWith
		{
			_index = 3;
		};
		
		_index = 0;
	};
	
	private _return = (TCL_Radio select 2 select _index);
	
	_return
	
	}
];