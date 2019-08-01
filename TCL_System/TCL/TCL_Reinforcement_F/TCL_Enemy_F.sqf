#include "TCL_Macros.hpp"

TCL_Enemy_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Enemy Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Enemy
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group"];
	
	private _leader = (leader _group);
	
	private _units = (TCL_Players select 0);
	
	if (TCL_System select 3) then
	{
		_units = (TCL_Players select 1);
	};
	
	_units = _units select { ( (alive _x) && { (side _group getFriend side _x < 0.6) } ) };
	
	if (alive _enemy) then
	{
		_units = _units select { ( ( (_group knowsAbout vehicle _x) >= (_group knowsAbout vehicle _enemy) ) && { ( (_leader distance _x) < (_leader distance _enemy) ) } ) };
	};
	
	private "_unit";
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (_group knowsAbout vehicle _unit > 0 ) exitWith
		{
			_enemy = _unit;
		};
	};
	
	_enemy
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Enemy Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Enemy
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _knowsAbout = (_group getVariable "TCL_KnowsAbout");
	
	private _ai = (_group getVariable "TCL_AI" select 10);
	
	private _value = ["TCL_Time", (time + _ai) ];
	
	if ( (alive _enemy) && { (_group knowsAbout vehicle _enemy > 0) } ) then
	{
		_knowsAbout = 0;
		
		_logic setVariable _value;
		
		_group setVariable _value;
	}
	else
	{
		if (_group in (TCL_Reinforcement select 1) ) then
		{
			_knowsAbout = 0;
		}
		else
		{
			if (_knowsAbout > 3) then
			{
				private _time = (_group getVariable "TCL_Time");
				
				if (time > _time) then
				{
					private _array = ( (TCL_Hold select 0) + (TCL_Join select 0) + (TCL_Defend select 0) + (TCL_Artillery select 0) );
					
					if (_group in _array) then
					{
						(TCL_Retreat select 0) pushBack _group;
					}
					else
					{
						_group setVariable _value;
					};
				};
			};
			
			_knowsAbout = _knowsAbout + 1;
		};
	};
	
	_group setVariable ["TCL_KnowsAbout", _knowsAbout];
	
	if (_knowsAbout == 3) then
	{
		(TCL_Reinforcement select 2) pushBack _group;
	}
	else
	{
		if (_knowsAbout == 0) then
		{
			if (_group in (TCL_Reinforcement select 2) ) then
			{
				TCL_DeleteAT(TCL_Reinforcement,2,_group);
			};
		};
	};
	
	if (_group in (TCL_Sneaking select 0) ) then
	{
		private _leader = (leader _group);
		
		if ( (_leader distance _logic < 100) || ( [_enemy, _group] call (TCL_Sneaking_F select 0) ) ) then
		{
			private _units = (units _group);
			
			{_x setUnitPos "AUTO"} count _units;
			
			TCL_DeleteAT(TCL_Sneaking,0,_group);
			
			[_group] call (TCL_Behaviour_F select 0);
		};
	};
	
	True
	
	}
];