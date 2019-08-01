#include "TCL_Macros.hpp"

TCL_Tank_F = [
	
	// ////////////////////////////////////////////////////////////////////////////
	// Tank Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Tank
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic","_units"];
	
	private _vehicle = (vehicle _enemy);
	
	if ( (_vehicle isKindOf "Tank") && { (isEngineOn _vehicle) } ) then
	{
		private ["_unit","_weapon","_array"];
		
		private _count = 0;
		
		for "_count" from _count to (count _units - 1) do
		{
			_unit = (_units select _count);
			
			_weapon = (secondaryWeapon _unit);
			
			_array = [];
			
			if (_weapon isKindOf ["Launcher", configFile >> "CfgWeapons"] ) exitWith
			{
				_array = (magazines _unit) select { (getText (configfile >> "CfgMagazines" >> _x >> "displayNameShort") isEqualTo "AT") };
				
				// player sideChat format ["TCL_Tank_F > Magazines > %1 > %2", _unit, _array];
				
				if (_array isEqualTo [] ) exitWith
				{
					// [_enemy, _group, _logic] call (TCL_Static_Weapon_F select 0);
				};
				
				// _unit selectWeapon _weapon;
				
				[_unit, _enemy, _weapon] spawn (TCL_Tank_F select 1);
				
				// _muzzle = (weaponState _unit select 1);
				
				// _unit fireAtTarget [_enemy, _weapon];
				
				// _unit fire _weapon;
				
				// _unit doTarget _enemy;
				
				// _unit doWatch _enemy;
				
				// _unit fire _weapon;
				
				// _unit action ["USEWEAPON", _weapon, _enemy, 1];
				
				// _unit doFire _enemy;
			};
			
			if (False) then
			{
				// [_enemy, _group, _logic] call (TCL_Static_Weapon_F select 0);
			};
			
			// player sideChat format ["TCL_Tank_F > Magazines > %1 > %2", _unit, _array];
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Tank Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Tank
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_enemy","_weapon"];
	
	private _vehicle = (vehicle _enemy);
	
	_unit forceSpeed 0;
	
	_unit doWatch _vehicle;
	
	// _unit disableAI "AUTOCOMBAT";
	
	// _unit setBehaviour "CARELESS";
	
	_unit doFire _vehicle;
	
	_unit doTarget _vehicle;
	
	_unit selectWeapon _weapon;
	
	// player sideChat format ["TCL_Tank_F > Unit > %1 > %2", _unit, _vehicle];
	
	sleep 3;
	
	// _unit doFire _vehicle;
	
	// _unit commandTarget _vehicle;
	
	// _unit commandFire _vehicle;
	
	_unit fire _weapon;
	
	// _unit fireAtTarget [_vehicle, _weapon];
	
	sleep 3;
	
	_unit forceSpeed -1;
	
	}
];