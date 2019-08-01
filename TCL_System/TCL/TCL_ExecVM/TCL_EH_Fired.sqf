// ////////////////////////////////////////////////////////////////////////////
// Event Handler Fired ExecVM
// ////////////////////////////////////////////////////////////////////////////
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////
private ["_units","_count","_unit"];

while { (True) } do
{
	_units = allUnits;
	
	_units = _units - (TCL_EH_Fired select 0);
	
	if (_units isEqualTo [] ) then
	{
		sleep 5;
	}
	else
	{
		(TCL_EH_Fired select 0) append _units;
		
		_count = 0;
		
		for "_count" from _count to (count _units - 1) do
		{
			_unit = (_units select _count);
			
			_unit addEventHandler ["FiredMan", {_this call (TCL_EH_Fired_F select 0) } ];
		};
	};
};