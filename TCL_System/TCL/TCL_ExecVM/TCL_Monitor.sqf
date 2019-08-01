#include "TCL_Macros.hpp"

/*  ////////////////////////////////////////////////////////////////////////////////
\   \ Monitor ExecVM
 \   \------------------------------------------------------------------------------
  \   \ By =\SNKMAN/=
  /   /-----------------------------------------------------------------------------
*/   ///////////////////////////////////////////////////////////////////////////////
private ["_array","_vehicle"];

_temp = [];

while { (True) } do
{
	if (True) then
	{
		_array = (TCL_Heal select 0);
		
		if (_array isEqualTo [] ) exitWith {};
		
		_array = (TCL_Heal select 0);
		
		_array = (TCL_Heal select 0) select { (alive _x) };
		
		TCL_Heal set [0, _array];
		
		_array = (TCL_Heal select 1);
		
		_array = (TCL_Heal select 1) select { (alive _x) };
		
		TCL_Heal set [1, _array];
	};
	
	if (True) then
	{
		_array = (TCL_Rearm select 0);
		
		if (_array isEqualTo [] ) exitWith {};
		
		_array = (TCL_Rearm select 0);
		
		_array = (TCL_Rearm select 0) select { (alive _x) };
		
		TCL_Rearm set [0, _array];
		
		_array = (TCL_Rearm select 1);
		
		_array = (TCL_Rearm select 1) select { (alive _x) };
		
		TCL_Rearm set [1, _array];
	};
	
	if (True) then
	{
		_array = (TCL_Flanking select 0);
		
		if (_array isEqualTo [] ) exitWith {};
		
		_array = (TCL_Flanking select 1);
		
		_array = (TCL_Flanking select 1) select { (alive _x) };
		
		TCL_Flanking set [1, _array];
		
		_array = (TCL_Flanking select 2);
		
		_array = (TCL_Flanking select 2) select { (alive _x) };
		
		TCL_Flanking set [2, _array];
	};
	
	if (True) then
	{
		_array = (TCL_Artillery select 0);
		
		if (_array isEqualTo [] ) exitWith {};
		
		_array = _array select {_vehicle = (vehicle leader _x); (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") };
		
		TCL_Artillery set [0, _array];
	};
	
	sleep 30;
};