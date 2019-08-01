#include "TCL_Macros.hpp"

TCL_Mortar_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Mortar Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Mortar
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_group","_vehicle"];
	
	if (_group in (TCL_Reinforcement select 0) ) then
	{
		private _enemy = (_group getVariable "TCL_Enemy");
		
		if ( (alive _enemy) && { (_group knowsAbout vehicle _enemy > 0) } ) then
		{
			private _leader = (leader _group);
			
			(TCL_Static_Weapon select 2) pushBack _vehicle;
			
			private _logic = (_group getVariable "TCL_Logic");
			
			private _magazine = (getArtilleryAmmo [_vehicle] select 0);
			
			private _position = [ (getPos _logic select 0) + (random 50 - random 50), (getPos _logic select 1) + (random 50 - random 50), 0];
			
			private _bool = [_vehicle, _position] call (TCL_Artillery_F select 2);
			
			private _range = (getPos _logic) inRangeOfArtillery [crew _vehicle, _magazine];
			
			if ( (_bool) && { (_range) } ) then
			{
				private _condition = (_logic getVariable "TCL_Artillery");
				
				_condition set [1, True];
				
				sleep 5 + (random 10);
				
				// private _count = 1 + (random 3);
				
				if (canFire _vehicle) then
				{
					private _rounds = (_unit ammo currentMuzzle gunner _vehicle);
					
					_rounds = (_rounds / 3);
					
					// private _count = (random _rounds);
					
					_time = _vehicle getArtilleryETA [_position, _magazine];
					
					_vehicle doArtilleryFire [_position, _magazine, _rounds];
					
					sleep _time;
					
					// sleep (10 * _count);
				};
				
				_condition set [1, False];
				
				TCL_DeleteAT(TCL_Static_Weapon,2,_vehicle);
			}
			else
			{
				if (_leader in (TCL_Static_Weapon select 0) ) exitWith {};
				
				// player sideChat format ["TCL_Mortar_F > Vehicle > %1", _vehicle];
				
				_unit leaveVehicle _vehicle; [_unit] orderGetIn False; [_unit] allowGetIn False;
				
				sleep 30 + (random 50);
				
				TCL_DeleteAT(TCL_Static_Weapon,2,_vehicle);
			};
		};
	};
	
	}
];