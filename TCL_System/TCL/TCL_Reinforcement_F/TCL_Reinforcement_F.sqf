#include "TCL_Macros.hpp"

TCL_Reinforcement_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private "_groups";
	
	private _leader = (leader _group);
	
	private _ai = (_group getVariable "TCL_AI");
	
	{ (TCL_Reinforcement select _x) pushBack _group} forEach [0,1];
	
	if (isNil { (_logic getVariable "TCL_Reinforcement") } ) then
	{
		(TCL_Request select 0) pushBack _group;
		
		_logic setVariable ["TCL_AI", _ai];
		
		_logic setVariable ["TCL_Reinforcement", [_group] ];
		
		if (_group in (TCL_Hold select 0) ) exitWith {};
		
		if (floor (random 100) < 15) then
		{
			[_enemy, _group] call (TCL_Sneaking_F select 0);
			
			// player sideChat format ["TCL_Reinforcement_F > Sneaking > %1", _group];
		}
		else
		{
			if ( (floor (random 100) < 35) && { ( { (alive _x) } count (units _group) < { (alive _x) } count (units _enemy) ) } ) then
			{
				if (_leader distance _enemy > 300) then
				{
					(TCL_Waiting select 0) pushBack _group;
					
					private _time = (time + 50);
					
					_time = _time + (random 70);
					
					_group setVariable ["TCL_Waiting", _time];
				};
			};
		};
	}
	else
	{
		_groups = (_logic getVariable "TCL_Reinforcement");
		
		_groups pushBack _group;
		
		if (floor (random 100) < 15) then
		{
			[_enemy, _group] call (TCL_Sneaking_F select 0);
		};
	};
	
	if (_group in (TCL_Location select 0) ) then
	{
		_groups = (_group getVariable "TCL_Location");
		
		_ai set [2, count _groups];
	};
	
	private _units = (units _group);
	
	if (_group in (TCL_Garrison select 0) ) then
	{
		// _units doFollow _leader;
		
		if (_group in (TCL_Hold select 0) ) exitWith {};
		
		private _array = (_group getVariable "TCL_Garrison");
		
		TCL_DeleteAT(TCL_Garrison,0,_group);
		
		TCL_Garrison set [1, (TCL_Garrison select 1) - _array];
	};
	
	if (TCL_Feature select 19) then
	{
		if (floor (random 100) < (TCL_Feature select 20) ) then
		{
			if (floor (random 100) < 50) then
			{
				(TCL_Flanking select 3) pushBack _group;
			};
			
			[_group] call (TCL_Flanking_F select 0);
		};
	};
	
	private _time = (_ai select 10);
	
	_group setVariable ["TCL_Time", (time + _time) ];
	
	[_enemy, _group, _logic] execFSM (TCL_Path+"TCL\TCL_Reinforcement_F\TCL_System.fsm");
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	if (alive _enemy) then
	{
		if ( [_enemy, _group, _logic] call (TCL_Reinforcement_F select 2) ) then
		{
			private _x = [_enemy, _group] call (TCL_Reinforcement_F select 3);
			
			private _units = (units _x);
			
			if (_units findIf { (alive _x) } > -1) then
			{
				private _leader = (leader _x);
				
				if (_x in (TCL_Join select 0) ) exitWith
				{
					TCL_DeleteAT(TCL_Join,0,_x);
				};
				
				if (isNull objectParent _leader) then
				{
					_leader playMove "Acts_listeningToRadio_Loop";
					
					[_leader] spawn
					{
						params ["_leader"];
						
						private _value = 5 + (random 7);
						
						sleep _value;
						
						_leader switchMove "";
					};
				};
				
				private _ai = (_logic getVariable "TCL_AI");
				
				if (_ai select 11) then
				{
					_x setVariable ["TCL_AI", _condition];
				};
				
				[_enemy, _x, _logic] call (TCL_Reinforcement_F select 0);
				
				private _vehicle = (vehicle _leader);
				
				if (_vehicle isKindOf "Helicopter") then
				{
					[_enemy, _group, _vehicle] spawn (TCL_Smoke_F select 0);
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _return = False;
	
	private _groups = (_logic getVariable "TCL_Reinforcement");
	
	if (_group in (TCL_Location select 0) ) then
	{
		private _array = (_group getVariable "TCL_Location");
		
		{if (_x in _groups) then {_x = _x} else {_return = True} } count _array;
	}
	else
	{
		if (_group in (TCL_Join select 0) ) then
		{
			_return = False;
		}
		else
		{
			_groups = _groups - (TCL_Join select 0);
			
			private _ai = (_group getVariable "TCL_AI" select 2);
			
			_ai = _ai + 1;
			
			if (count _groups < _ai) then
			{
				_return = True;
			};
			
			// player sideChat format ["TCL_Reinforcement_F > Request > %1 > %2 > %3", _group, (count _groups), _ai];
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Reinforcement
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group"];
	
	private _groups = (TCL_Groups select 0);
	
	if (_group in (TCL_Location select 0) ) then
	{
		_groups = (_group getVariable "TCL_Location");
	}
	else
	{
		_groups = _groups - (TCL_Location select 0);
	};
	
	private _array = ( (TCL_Hold select 0) + (TCL_Zeus select 1) + (TCL_Defend select 0) + (TCL_Freeze select 0) + (TCL_Default select 0) + (TCL_Artillery select 0) + (TCL_Reinforcement select 0) );
	
	_groups = _groups - _array;
	
	_groups append (TCL_Join select 0);
	
	private _return = grpNull;
	
	if (_groups isEqualTo [] ) exitWith {_return};
	
	if ( [_enemy, _group] call (TCL_Rating_F select 0) ) then
	{
		private _leader = (leader _group);
		
		private _condition = [_group] call (TCL_Radio_F select 2);
		
		private ["_distance","_units","_bool"];
		
		{_distance = (_leader distance leader _x);
		
		if (_distance < _condition) then
		{
			_units = (units _x);
			
			if ( (_units findIf { (alive _x) } > -1) && { (side _group getFriend side _x > 0.6) } ) then
			{
				if (side _x getFriend side _enemy < 0.6) then
				{
					_bool = [_group, _x] call (TCL_Radio_F select 0);
					
					if (_bool) then
					{
						_return = _x;
						
						_condition = _distance;
					};
				};
			};
		};
		
		} count _groups;
	};
	
	_return
	
	}
];