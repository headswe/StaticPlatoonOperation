TCL_EH_Killed_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Killed Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Killed
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle"];
	
	if (TCL_Server) then
	{
		if (_vehicle isKindOf "Tank") then
		{
			if (TCL_FX select 11) then
			{
				if (floor (random 100) < (TCL_FX select 12) ) then
				{
					private _crew = (crew _vehicle);
					
					if (_crew isEqualTo [] ) exitWith {};
					
					[_crew, _vehicle] spawn (TCL_Crew_FX_F select 0);
				};
			};
		};
		
		[_vehicle] call (TCL_EH_Killed_F select 1);
	};
	
	if (TCL_Dedicated) exitWith {};
	
	if (TCL_FX select 13) then
	{
		[_vehicle] spawn (TCL_Explosion_FX_F select 0);
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Killed Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Killed
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle"];
	
	private _size = (sizeOf typeOf _vehicle);
	
	private _distance = (_size * 50);
	
	private _array = ( (TCL_Garrison select 0) + (TCL_Advancing select 0) + (TCL_Reinforcement select 0) );
	
	[_vehicle, _array, _distance] call (TCL_Feature_F select 2);
	
	True
	
	}
];