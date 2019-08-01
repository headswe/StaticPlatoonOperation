#include "TCL_Macros.hpp"

/*  ////////////////////////////////////////////////////////////////////////////////
\   \ Spawn ExecVM
 \   \------------------------------------------------------------------------------
  \   \ By =\SNKMAN/=
  /   /-----------------------------------------------------------------------------
*/   ///////////////////////////////////////////////////////////////////////////////
private ["_temp","_players","_groups","_array","_count","_group","_vehicles","_vehicle"];

_temp = [];

while { (True) } do
{
	_players = (playableUnits + switchableUnits);
	
	if (True) then
	{
		_players = _players - (TCL_Players select 0);
		
		_array = (TCL_Players select 0) select { (alive _x) };
		
		TCL_Players set [0, _array];
		
		_array = (TCL_Players select 1) select { (alive _x) };
		
		TCL_Players set [1, _array];
		
		if (_players isEqualTo [] ) exitWith {};
		
		[_players] call (TCL_Players_F select 0);
		
		// player sideChat format ["TCL_Spawn > Players > %1", _players];
	};
	
	_groups	= allGroups;
	
	if (True) then
	{
		_groups = _groups - (TCL_Groups select 0);
		
		_array = ( (TCL_Disabled select 0) + (TCL_Players select 2) );
		
		_groups = _groups - _array;
		
		_groups = _groups select { ( (side _x in (TCL_System select 2) ) && { (units _x findIf { (alive _x) } > -1) } ) };
		
		_temp = _temp - [grpNull];
		
		_groups = _groups - _temp;
		
		if (_groups isEqualTo [] ) exitWith {};
		
		_temp = _temp - (TCL_Groups select 0);
		
		_temp append _groups;
		
		_count = 0;
		
		for "_count" from _count to (count _groups - 1) do
		{
			_group = (_groups select _count);
			
			[_group] spawn TCL_Spawn_F;
		};
		
		// player sideChat format ["TCL_Spawn > Groups > %1 > %2", _groups, _temp];
	};
	
	_vehicles = vehicles;
	
	if (True) then
	{
		_array = ( (TCL_Vehicles select 0) + (TCL_Vehicles select 1) );
		
		_vehicles = _vehicles - _array;
		
		_array = _vehicles select { ( (_x isKindOf "WeaponHolderSimulated") || (typeOf _x == "Steerable_Parachute_F") ) };
		
		_vehicles = _vehicles - _array;
		
		(TCL_Vehicles select 1) append _array;
		
		if (_vehicles isEqualTo [] ) exitWith {};
		
		[_vehicles] call (TCL_Vehicles_F select 0);
		
		// player sideChat format ["TCL_Spawn > Vehicles > %1", _vehicles];
	};
	
	if (True) then
	{
		_array = (TCL_Artillery select 0);
		
		if (_array isEqualTo [] ) exitWith {};
		
		_array = _array select {_vehicle = (vehicle leader _x); (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") };
		
		TCL_Artillery set [0, _array];
	};
	
	sleep 5;
};