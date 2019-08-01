#include "TCL_Macros.hpp"

TCL_Logic_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Logic Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Logic
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy"];
	
	private _side = createCenter sideLogic;
	
	private _group = createGroup _side;
	
	private _logic = _group createUnit ["Logic", (getPos _enemy), [], 0, "NONE"];
	
	[_logic] join _group;
	
	_logic allowDamage False;
	
	_logic
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Logic Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Logic
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_logic","_spot"];
	
	if (alive _spot) then
	{
		deleteVehicle _spot;
	};
	
	private _units = (units _group);
	
	private _array = (_logic getVariable "TCL_Reinforcement");
	
	{TCL_DeleteAT(TCL_Reinforcement,_x,_group) } forEach [0,1,2];
	
	{TCL_DeleteAT(_x,0,_group) } forEach [TCL_Red, TCL_Join, TCL_Retreat, TCL_Request, TCL_Waiting, TCL_Sneaking, TCL_Flanking, TCL_Behaviour];
	
	if (_units findIf { (alive _x) } < 0) then
	{
		["TCL_Position", _group] call (TCL_Marker_F select 0);
	};
	
	_array deleteAt (_array find _group);
	
	if (_array isEqualTo [] ) then
	{
		TCL_DeleteAT(TCL_Logic,0,_logic);
		
		["TCL_Delete", _logic] call (TCL_Marker_F select 0);
		
		deleteVehicle _logic;
	};
	
	True
	
	}
];