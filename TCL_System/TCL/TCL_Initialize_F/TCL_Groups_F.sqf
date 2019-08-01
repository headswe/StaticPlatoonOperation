#include "TCL_Macros.hpp"

TCL_Groups_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_groups"];
	
	private _array = [];
	
	_array append _groups;
	
	private ["_group","_units","_objects"];
	
	private _count = 0;
	
	for "_count" from _count to (count _groups - 1) do
	{
		_group = (_groups select _count);
		
		_units = (units _group);
		
		if (_units findIf { (alive _x) } > -1) then
		{
			_objects = [];
			
			{_objects append (synchronizedObjects _x) } count _units;
			
			{ [_x, _group, _objects] call (TCL_Groups_F select 1) } count ["TCL_Idle","TCL_Hold","TCL_Defend","TCL_Custom","TCL_Freeze","TCL_Default","TCL_Disabled","TCL_Enhanced","TCL_Location"];
		};
	};
	
	if (count (TCL_Custom select 0) > 0) then
	{
		_array = ( (TCL_Hold select 0) + (TCL_Defend select 0) + (TCL_Custom select 0) + (TCL_Location select 0) );
		
		_array = (_array arrayIntersect _array);
		
		_groups = _groups - _array;
		
		(TCL_Disabled select 0) append _groups;
		
		private _sort = (TCL_Initialized select 0);
		
		_sort = _sort - _array;
		
		_sort = _sort - (TCL_Disabled select 0);
		
		(TCL_Disabled select 0) append _sort;
	};
	
	_array = _array - (TCL_Players select 2);
	
	_array = _array - (TCL_Disabled select 0);
	
	_array = _array - (TCL_Initialized select 0);
	
	_array = _array select { (side _x in (TCL_System select 2) ) };
	
	{ [_x] call (TCL_Get_In_F select 0); [_x] call (TCL_Groups_F select 7); [units _x] call (TCL_Units_F select 0); [_x] spawn (TCL_Garrison_F select 0) } forEach _array;
	
	(TCL_Groups select 0) append _array;
	
	(TCL_Initialized select 0) append _array;
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_group","_objects"];
	
	if (_type isEqualTo "TCL_Location") then
	{
		[_group, _objects] call (TCL_Groups_F select 2);
	}
	else
	{
		if (isNil {_group getVariable _type} ) then
		{
			private _bool = [_type, _group] call (TCL_Groups_F select 3);
			
			if (_bool) then
			{
				_bool = [_type, _group, _objects] call (TCL_Groups_F select 4);
				
				if (_bool) then
				{
					[_type, _group] call (TCL_Groups_F select 5);
				};
			};
		}
		else
		{
			if (_group getVariable _type) then
			{
				[_type, _group] call (TCL_Groups_F select 6);
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group","_units"];
	
	private _array = _units select { (side _x isEqualTo sideLogic) };
	
	_units = _units - _array;
	
	if (_units isEqualTo [] ) exitWith {True};
	
	_array = [];
	
	private "_unit";
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (units _unit findIf { (alive _x) } > -1) then
		{
			_array pushBackUnique (group _unit);
		};
	};
	
	if (_array isEqualTo [] ) exitWith {True};
	
	_array pushBack _group;
	
	{ (TCL_Location select 0) pushBackUnique _x} forEach _array;
	
	_group setVariable ["TCL_Location", _array];
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_group"];
	
	private _return = True;
	
	private _units = (units _group);
	
	private "_unit";
	
	private _count = 0;
	
	for "_count" from _count to (count _units - 1) do
	{
		_unit = (_units select _count);
		
		if (isNil {_unit getVariable _type} ) then
		{
			_return = _return;
		}
		else
		{
			if (_unit getVariable _type) then
			{
				_return = False;
				
				_count = (count _units);
				
				[_type, _group] call (TCL_Groups_F select 6);
			};
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #4
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_group","_objects"];
	
	private _return = True;
	
	if (_objects isEqualTo [] ) exitWith {_return};
	
	_objects = _objects select { (triggerText _x == _type) };
	
	private "_object";
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_object = (_objects select _count);
		
		if (_object isKindOf "EmptyDetector") exitWith
		{
			_return = False;
			
			[_type, _group] call (TCL_Groups_F select 6);
		};
	};
	
	_return
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #5
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_group"];
	
	private _objects = allMissionObjects "EmptyDetector";
	
	if (_objects isEqualTo [] ) exitWith {True};
	
	private _leader = (leader _group);
	
	_objects = _objects select { (triggerText _x == _type) };
	
	private "_object";
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_object = (_objects select _count);
		
		if (_leader inArea _object) exitWith
		{
			[_type, _group, _object] call (TCL_Groups_F select 6);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #6
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_group"];
	
	private _string = call compile _type;
	
	private _array = (_string select 0);
	
	if (_group in _array) exitWith
	{
		private _error = [];
		
		_error pushBack _group;
		
		_error pushBack format ["<t color='#ffff00'>( %1 )</t>", count units _group];
		
		private _text = _error joinString " ";
		
		hint parseText format ["%1<t align='left'>A.I. group <t color='#32cd32'>%2</t> was about to initialize multiple times in the same A.I. group type '<t color='#32cd32'>%3</t>'.<br/>Please make sure to use any A.I. group type for each A.I. group except '<t color='#32cd32'>Location</t>' A.I. group(s) ONCE only.", (TCL_Text_F select 3), _text, _type];
	};
	
	if (_type == "TCL_Idle") exitWith
	{
		(TCL_Idle select 0) pushBack _group;
	};
	
	if (_type == "TCL_Hold") exitWith
	{
		(TCL_Hold select 0) pushBack _group;
		
		private "_object";
		
		if (count _this == 3) then
		{
			_object = _this select 2;
		}
		else
		{
			private _leader = (leader _group);
			
			_object = createTrigger ["EmptyDetector", (getPos _leader) ];
			
			_object setTriggerArea [50, 50, 0, False];
			
			private _side = format ["%1", (side _leader) ];
			
			_object setTriggerActivation [_side, "PRESENT", False];
		};
		
		_group setVariable ["TCL_Enemy", objNull];
		
		_group setVariable ["TCL_Trigger", _object];
		
		["TCL_Marker", _group, _object] call (TCL_Marker_F select 0);
	};
	
	if (_type == "TCL_Defend") exitWith
	{
		(TCL_Defend select 0) pushBack _group;
	};
	
	if (_type == "TCL_Custom") exitWith
	{
		(TCL_Custom select 0) pushBack _group;
	};
	
	if (_type == "TCL_Freeze") exitWith
	{
		(TCL_Freeze select 0) pushBack _group;
	};
	
	if (_type == "TCL_Default") exitWith
	{
		(TCL_Default select 0) pushBack _group;
	};
	
	if (_type == "TCL_Disabled") exitWith
	{
		(TCL_Disabled select 0) pushBack _group;
	};
	
	if (_type == "TCL_Enhanced") exitWith
	{
		(TCL_Freeze select 0) pushBack _group;
		
		(TCL_Default select 0) pushBack _group;
		
		(TCL_Enhanced select 0) pushBack _group;
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Groups Function #7
	// ////////////////////////////////////////////////////////////////////////////
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _random = (random 15);
	
	private _units = (units _group);
	
	private _leader = (leader _group);
	
	_group setVariable ["TCL_Move", 5];
	
	private _vehicle = (vehicle _leader);
	
	_group setVariable ["TCL_Enemy", objNull];
	
	_group setVariable ["TCL_Watch", (time + _random) ];
	
	_group setVariable ["TCL_Position", (getPos _leader) ];
	
	_group setVariable ["TCL_Waypoint", (getPos _leader) ];
	
	_group setVariable ["TCL_Behaviour", [ (behaviour _leader), (combatMode _group), (formation _group), (speedMode _group) ] ];
	
	if (getArray (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "availableForSupportTypes") select 0 isEqualTo "Artillery") then
	{
		(TCL_Artillery select 0) pushBack _group;
		
		_group setVariable ["TCL_Artillery", True];
		
		if (_group in (TCL_Location select 0) ) exitWith
		{
			TCL_DeleteAT(TCL_Location,0,_group);
		};
		
		// player sideChat format ["TCL_Groups_F > Artillery > %1", _group];
	};
	
	if (isNil { (_group getVariable "TCL_AI") } )then
	{
		_group setVariable ["TCL_AI", TCL_AI];
	}
	else
	{
		private _text = format ["%1<t align='left'>The '<t color='#32cd32'>TCL_AI</t>' settings of <t color='#ffff00'>%2</t> are not configurated properly!<br/>Please check the '<t color='#32cd32'>TCL_AI</t>' settings of <t color='#ffff00'>%2</t> and correct them.", (TCL_Text_F select 3), _group];
		
		private _array = TCL_AI;
		
		private _ai = (_group getVariable "TCL_AI");
		
		if (_array isEqualTypeArray _ai) then
		{
			_text = _text;
		}
		else
		{
			hint parseText _text;
		};
	};
	
	if (_group getVariable "TCL_AI" select 7) then
	{
		["TCL_Freeze", _group] call (TCL_Groups_F select 6);
	};
	
	if (_group getVariable "TCL_AI" select 8) then
	{
		["TCL_Default", _group] call (TCL_Groups_F select 6);
	};
	
	// player sideChat format ["TCL_Groups_F > Conditions > %1", _group];
	
	True
	
	}
];