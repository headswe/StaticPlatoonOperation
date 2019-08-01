#include "TCL_Macros.hpp"

TCL_Suppressed_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Suppressed Fire Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Suppressed Fire
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	private _distance = 300;
	
	private _leader = (leader _group);
	
	if ( (_group knowsAbout vehicle _unit > 0) && (_leader distance _unit < _distance) ) then
	{
		private _direction = [_unit, _leader] call TCL_Rel_Dir_To_F;
		
		// player sideChat format ["TCL_Suppressed_F > Direction > %1 > %2", _group, _direction];
		
		if ( (_direction > 340) || (_direction < 20) ) then
		{
			(TCL_Suppressed select 0) pushBack _group;
			
			[_unit, _group] spawn (TCL_Suppressed_F select 1);
			
			// player sideChat format ["TCL_Suppressed_F > Group > %1", _group];
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Suppressed Fire Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Suppressed Fire
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group"];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	private _behaviour = (behaviour _leader);
	
	_group setBehaviour "STEALTH";
	
	{_x setUnitPos "DOWN"} count _units;
	
	sleep 10 + (random 30);
	
	if (_units findIf { (alive _x) } > -1) then
	{
		_group setBehaviour _behaviour;
		
		{_x setUnitPos "AUTO"} count _units;
		
		sleep 10 + (random 30);
	};
	
	TCL_DeleteAT(TCL_Suppressed,0,_group);
	
	}
];