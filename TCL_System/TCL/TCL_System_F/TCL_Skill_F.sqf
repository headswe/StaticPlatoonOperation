TCL_Skill_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Skill Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Skill
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit"];
	
	if (TCL_System select 5) then
	{
		private _value = 1;
		
		private _system = (TCL_System select 6);
		
		_value = (_value + _system);
		
		private ["_type","_skill","_random"];
		
		private _count = 0;
		
		for "_count" from _count to 8 do
		{
			if (True) then
			{
				if (_count == 0) exitWith
				{
					_type = "general";
				};
				
				if (_count == 1) exitWith
				{
					_type = "courage";
				};
				
				if (_count == 2) exitWith
				{
					_type = "spotTime";
				};
				
				if (_count == 3) exitWith
				{
					_type = "spotDistance";
				};
				
				if (_count == 4) exitWith
				{
					_type = "aimingSpeed";
				};
				
				if (_count == 5) exitWith
				{
					_type = "aimingShake";
				};
				
				if (_count == 6) exitWith
				{
					_type = "aimingAccuracy";
				};
				
				if (_count == 7) exitWith
				{
					_type = "reloadSpeed";
				};
				
				if (_count == 8) exitWith
				{
					_type = "commanding";
				};
			};
			
			_skill = (_unit skill _type);
			
			// player sideChat format ["TCL_Skill_F > Skill > %1 > %2 > %3", _unit, _type, (_unit skillFinal _type) ];
			
			_random = (_skill / _value);
			
			_skill = (_skill + _random);
			
			_unit setSkill [_type, _skill];
			
			// player sideChat format ["TCL_Skill_F > Skill > %1 > %2 > %3", _unit, _type, (_unit skillFinal _type) ];
		};
	};
	
	True
	
	}
];