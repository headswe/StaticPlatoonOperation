TCL_Vehicles_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Vehicles Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicles"];
	
	(TCL_Vehicles select 0) append _vehicles;
	
	private "_vehicle";
	
	private _count = 0;
	
	for "_count" from _count to (count _vehicles - 1) do
	{
		_vehicle = (_vehicles select _count);
		
		if (TCL_Multiplayer) then
		{
			_vehicle addMPEventHandler ["MPKilled", {_this call (TCL_EH_Killed_F select 0) } ];
		}
		else
		{
			_vehicle addEventHandler ["Killed", {_this call (TCL_EH_Killed_F select 0) } ];
		};
	};
	
	True
	
	}
];