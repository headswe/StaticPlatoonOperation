/*  ////////////////////////////////////////////////////////////////////////////////
\   \ Zeus ExecVM
 \   \------------------------------------------------------------------------------
  \   \ By =\SNKMAN/=
  /   /-----------------------------------------------------------------------------
*/   ///////////////////////////////////////////////////////////////////////////////
params ["_curators"];

waitUntil { ( (alive player) && (time > 0) ) };

private _bool = True;

private _curator = objNull;

private ["_count","_curator","_unit","_array"];

while { (_bool) } do
{
	_count = 0;
	
	for "_count" from _count to (count _curators - 1) do
	{
		_curator = (_curators select _count);
		
		_unit = (getAssignedCuratorUnit _curator);
		
		if (_unit == player) exitWith
		{
			_bool = False;
			
			(TCL_Curator select 0) pushBack _curator;
			
			publicVariable "TCL_Curator";
			
			// player sideChat format ["TCL_Zeus.sqf > Curator > %1", _curator];
		};
	};
	
	_array = (TCL_Curator select 0);
	
	if (_array isEqualTo _curators) exitWith {};
	
	// player sideChat format ["TCL_Zeus.sqf > Curators > %1 > %2", time, _curators];
	
	sleep 1;
};

if (alive _curator) then
{
	_curator addEventHandler ["CuratorObjectPlaced", {_this spawn (TCL_EH_Zeus_F select 0) } ];
	
	_curator addEventHandler ["CuratorWaypointPlaced", {_this call (TCL_EH_Zeus_F select 1) } ];
	
	_curator addEventHandler ["CuratorWaypointDeleted", {_this call (TCL_EH_Zeus_F select 2) } ];
};