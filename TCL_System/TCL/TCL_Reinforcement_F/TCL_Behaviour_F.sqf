#include "TCL_Macros.hpp"

TCL_Behaviour_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Behaviour Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Behaviour
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private ["_behaviour","_combatMode","_speedMode","_formation"];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	if (_group in (TCL_Reinforcement select 1) ) then
	{
		if (isNull objectParent _leader) then
		{
			_behaviour = "AWARE";
		}
		else
		{
			_behaviour = selectRandom ["SAFE","SAFE","AWARE","AWARE"];
			
			private _vehicle = (vehicle _leader);
			
			if (_vehicle isKindOf "Air") then
			{
				_behaviour = "AWARE";
			};
		};
		
		_combatMode = "YELLOW";
		
		if (combatMode _group isEqualTo "RED") then
		{
			_combatMode = "RED";
			
			(TCL_Red select 0) pushBack _group;
		};
		
		if (_group in (TCL_Sneaking select 0) ) then
		{
			_behaviour = (behaviour _leader);
			_combatMode = (combatMode _group);
		};
		
		if (speedMode _group isEqualTo "NORMAL") then
		{
			(TCL_Speed select 0) pushBack _group;
		}
		else
		{
			_group setVariable ["TCL_Speed", (speedMode _group) ];
		};
		
		_speedMode = selectRandom ["FULL","FULL","FULL","FULL"];
		_formation = selectRandom ["WEDGE","COLUMN","STAG COLUMN"];
	}
	else
	{
		_behaviour = "COMBAT";
		
		private _random = (TCL_Tweak select 0);
		
		if (floor (random 100) < _random) then
		{
			{_x disableAI "AUTOCOMBAT"} count _units;
			
			_behaviour = "AWARE";
		};
		
		_combatMode = "YELLOW";
		
		if (_group in (TCL_Red select 0) ) then
		{
			_combatMode = "RED";
		}
		else
		{
			if (floor (random 100) < 50) then
			{
				_combatMode = "RED";
			};
		};
		
		if (_group in (TCL_Sneaking select 0) ) then
		{
			_behaviour = (behaviour _leader);
			_combatMode = (combatMode _group);
		};
		
		_formation = selectRandom ["WEDGE","WEDGE","ECH LEFT","ECH RIGHT","VEE"];
		
		if (_group in (TCL_Speed select 0) ) then
		{
			_speedMode = selectRandom ["NORMAL","FULL"];
		}
		else
		{
			_speedMode = (_group getVariable "TCL_Speed");
		};
	};
	
	if (behaviour _leader isEqualTo "STEALTH") then
	{
		_behaviour = "STEALTH";
	};
	
	_group setSpeedMode _speedMode;
	
	_group setFormation _formation;
	
	_group setBehaviour _behaviour;
	
	_group setCombatMode _combatMode;
	
	_units doFollow _leader;
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Behaviour Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Behaviour
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	{_x setUnitPos "AUTO"} count _units;
	
	private _speedMode = (speedMode _group);
	
	private _formation = (formation _group);
	
	private _behaviour = (behaviour _leader);
	
	(TCL_Behaviour select 0) pushBack _group;
	
	private _combatMode = (combatMode _group);
	
	if (_leader distance _logic > 300) then
	{
		[_enemy, _group, _logic] spawn (TCL_Unassign_F select 0);
	};
	
	// player sideChat format ["TCL_Behaviour_F > Group > %1", _group];
	
	_group setSpeedMode "FULL";
	
	_group setBehaviour "AWARE";
	
	_group setCombatMode "YELLOW";
	
	if (floor (random 100) < 35) then
	{
		_group setFormation "WEDGE";
	}
	else
	{
		_group setFormation "STAG COLUMN";
	};
	
	_units = _units - (TCL_Helicopter select 0);
	
	_units doFollow _leader;
	
	{_x forceSpeed -1} count _units;
	
	private ["_waypoint","_knowsAbout"];
	
	while { ( (units _group findIf { (alive _x) } > -1) && { (_group in (TCL_Reinforcement select 0) ) } ) } do
	{
		_waypoint = (_group getVariable "TCL_Waypoint");
		
		_knowsAbout = (_group getVariable "TCL_KnowsAbout");
		
		if (_knowsAbout == 0) exitWith
		{
			_group setSpeedMode _speedMode;
			
			_group setFormation _formation;
			
			_group setBehaviour _behaviour;
			
			_group setCombatMode _combatMode;
		};
		
		if (_leader distance _waypoint < 100) then
		{
			if (behaviour _leader isEqualTo _behaviour) exitWith {};
			
			_group setBehaviour _behaviour;
		};
		
		sleep 5;
	};
	
	TCL_DeleteAT(TCL_Behaviour,0,_group);
	
	}
];