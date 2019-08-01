#include "TCL_Macros.hpp"

TCL_EH_Zeus_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_curator","_unit"];
	
	private _group = (group _unit);
	
	private _leader = (leader _group);
	
	private _vehicle = (vehicle _leader);
	
	// player sideChat format ["TCL_EH_Zeus_F > Unit > %1", _unit];
	
	if (_unit == _vehicle) then
	{
		// player sideChat format ["TCL_EH_Zeus_F > Vehicle > %1", (typeOf _unit) ];
		
		if (TCL_Server) then
		{
			(TCL_Zeus select 0) pushBack _group;
		}
		else
		{
			TCL_Host = [_group]; publicVariable "TCL_Host";
			
			// (TCL_Zeus select 0) pushBack _group; publicVariable "TCL_Zeus";
		};
		
		[_group] spawn (TCL_EH_Zeus_F select 3);
		
		// player sideChat format ["TCL_EH_Zeus_F > Group > %1", _group];
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_curator","_group","_waypoint"];
	
	if (TCL_Server) then
	{
		(TCL_Zeus select 1) pushBackUnique _group;
		
		(TCL_Freeze select 0) pushBackUnique _group;
		
		if (_group in (TCL_Garrison select 0) ) then
		{
			private _units = (units _group);
			
			private _leader = (leader _group);
			
			_units doFollow _leader;
			
			TCL_DeleteAT(TCL_Garrison,0,_group);
			
			private _array = (_group getVariable "TCL_Garrison");
			
			TCL_Garrison set [1, (TCL_Garrison select 1) - _array];
		};
	}
	else
	{
		TCL_Host = _this; publicVariable "TCL_Host";
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_curator","_group","_waypoint"];
	
	if (TCL_Server) then
	{
		private _array = (waypoints _group);
		
		if (count _array == 1) then
		{
			TCL_DeleteAT(TCL_Zeus,1,_group);
			
			TCL_DeleteAT(TCL_Freeze,0,_group);
			
			[_group] spawn (TCL_Garrison_F select 0);
		};
		
		// player sideChat format ["TCL_EH_Zeus_F > Waypoints > %1 > %2", _array, (count _array) ];
	}
	else
	{
		TCL_Host = _this; publicVariable "TCL_Host";
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Zeus
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _id = (groupId _group);
	
	private _string = format ["%1 ( Zeus ) ", _id];
	
	while { (True) } do
	{
		private _array = (waypoints _group);
		
		if (count _array == 1) then
		{
			_group setGroupId [_id];
		}
		else
		{
			_group setGroupId [_string];
		};
		
		if (False) then
		{
		
		if (_group in (TCL_Zeus select 1) ) then
		{
			_group setGroupId [_string];
		}
		else
		{
			_group setGroupId [_id];
		};
		
		};
		
		if (isNull _group) exitWith {};
		
		sleep 1;
	};
	
	}
];