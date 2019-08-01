#include "TCL_Macros.hpp"

/*  ////////////////////////////////////////////////////////////////////////////////
\   \ KnowsAbout ExecVM
 \   \------------------------------------------------------------------------------
  \   \ By =\SNKMAN/=
  /   /-----------------------------------------------------------------------------
*/   ///////////////////////////////////////////////////////////////////////////////
private ["_groups","_count","_group","_units","_time","_random","_array"];

// "AwareFormationSoft" enableAIFeature False;

// "CombatFormationSoft" enableAIFeature True;

// player sideChat format ["TCL_KnowsAbout.sqf > Feature > %1 > %2", (checkAIFeature "AwareFormationSoft"), (checkAIFeature "CombatFormationSoft") ];

while { (True) } do
{
	_groups = (TCL_Groups select 0);
	
	_groups = _groups - (TCL_Idle select 0);
	
	_groups = _groups - (TCL_Artillery select 0);
	
	_groups = _groups - (TCL_Reinforcement select 0);
	
	_count = 0;
	
	for "_count" from _count to (count _groups - 1) do
	{
		_group = (_groups select _count);
		
		_units = (units _group);
		
		if (_units findIf { (alive _x) } > -1) then
		{
			[_group] call (TCL_KnowsAbout_F select 0);
			
			if (TCL_Feature select 0) then
			{
				if (floor (random 100) < (TCL_Feature select 1) ) then
				{
					_time = (_group getVariable "TCL_Watch");
					
					if (time > _time) then
					{
						[_group] spawn (TCL_Watch_F select 0);
					};
					
					_random = (random 15);
					
					_group setVariable ["TCL_Watch", (time + _random) ];
				};
			};
		}
		else
		{
			TCL_DeleteAT(TCL_Groups,0,_group);
			
			if (_group in (TCL_Location select 0) ) then
			{
				_array = (_group getVariable "TCL_Location");
				
				TCL_DeleteAT(TCL_Location,0,_group);
				
				_array deleteAt (_array find _group);
				
				// player sideChat format ["TCL_KnowsAbout > Location > %1 > %2", _group, _groups];
				
				{_delete = (_x getVariable "TCL_Location"); _delete deleteAt (_delete find _group) } forEach _array;
			};
		};
	};
	
	sleep 1;
};