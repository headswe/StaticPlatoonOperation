#include "TCL_Macros.hpp"

TCL_Surrender_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Surrender Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Surrender
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _units = (units _group);
	
	private _unit = _units select random (count _units - 1);
	
	if ( (isPlayer _unit) || (captive _unit) || (fleeing _unit) || (_unit in (TCL_Surrender select 0) ) ) exitWith {};
	
	if (alive _unit) then
	{
		_unit setCaptive True;
		
		(TCL_Surrender select 0) pushBack _unit;
		
		private _bool = True;
		
		private _weapon = (primaryWeapon _unit);
		
		if (_weapon isEqualTo "") then
		{
			_bool = False;
		};
		
		private _dummy = createVehicle ["GroundWeaponHolder_Scripted", (getPos _unit), [], 0, "CAN_COLLIDE"];
		
		if (_bool) then
		{
			_unit forceSpeed 0;
			
			_unit action ["DropWeapon", _dummy, _weapon];
			
			waitUntil { (primaryWeapon _unit isEqualTo "") };
			
			_unit forceSpeed -1;
		};
		
		private _weapons = (weapons _unit);
		
		_weapons apply {_dummy addWeapon _x; _unit removeWeapon _x};
		
		private _magazines = (magazines _unit);
		
		_weapons apply {_dummy addMagazine _x; _unit removeMagazine _x};
		
		// _unit action ["Surrender", _unit]; 
		
		_unit playMove "AmovPercMstpSsurWnonDnon";
		
		// _units deleteAt (_units find _unit);
		
		[_unit, _dummy, _weapon] spawn (TCL_Surrender_F select 1);
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Surrender Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Surrender
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_dummy","_weapon"];
	
	// private _value = 1;
	
	private _courage = (_unit skill "courage");
	
	_courage = (_courage / 3);
	
	// _value = (_value - _courage);
	
	// player sideChat format ["TCL_Surrender_F > Courage > %1 > %2", _unit, _courage];
	
	private ["_random","_fleeing"];
	
	_fleeing = 0;
	
	while { ( (alive _unit) && { (captive _unit) } ) } do
	{
		_random = (random _courage);
		
		_fleeing = (_fleeing + _random);
		
		_unit allowFleeing _fleeing;
		
		sleep 10 + (random 30);
		
		if (fleeing _unit) exitWith
		{
			// _unit move [ (getPos _unit select 0) + (random 100) - (random 100), (getPos _unit select 1) + (random 100) - (random 100), 0];
			
			_unit switchMove "";
			
			// player sideChat format ["TCL_Surrender_F > Fleeing > %1 > %2", _unit, _fleeing];
			
			if (floor (random 100) < 50) then
			{
				if (True) exitWith
				{
					[_unit, _dummy, _dummy, _weapon] spawn (TCL_Rearm_F select 3);
				};
				
				_unit forceSpeed 0;
				
				_unit doWatch _dummy;
				
				_unit setUnitPos "MIDDLE";
				
				_unit action ["TakeWeapon", _dummy, _weapon];
				
				sleep 3;
				
				_unit action ["REARM", _dummy];
				
				_unit forceSpeed -1;
				
				_unit doWatch objNull;
				
				_unit setUnitPos "AUTO";
			};
			
			sleep 10 + (random 30);
			
			_unit setCaptive False;
		};
	};
	
	TCL_DeleteAT(TCL_Surrender,0,_unit);
	
	}
];