#include "TCL_Macros.hpp"

TCL_EH_Fired_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit"];
	
	if (False) then
	{
		_weapon = (currentWeapon _unit);
		
		_ammo = (_unit ammo _weapon);
		
		_ammo = _ammo + 1;
		
		_unit setAmmo [_weapon, _ammo];
	};
	
	if (TCL_Server) then
	{
		if (_unit in (TCL_Players select 0) ) then
		{
			if (TCL_Feature select 22) then
			{
				_this call (TCL_EH_Fired_F select 1);
			};
			
			if (TCL_Feature select 27) then
			{
				_this call (TCL_EH_Fired_F select 2);
			};
		};
	};
	
	if (TCL_Dedicated) exitWith {};
	
	private _ammo = _this select 4;
	
	if (_ammo isKindOf "BulletBase") then
	{
		if ( (TCL_FX select 0) && { (floor (random 100) < (TCL_FX select 1) ) } ) then
		{
			if (_unit == player) exitWith {};
			
			if ( (_unit distance player < 300) && { (count (TCL_Whiz_FX select 0) < 3) } ) then
			{
				private _bullet = _this select 6;
				
				[_unit, _bullet] call (TCL_Whiz_FX_F select 0);
			};
		};
		
		private _bullet = _this select 6;
		
		// [_bullet] spawn (TCL_Impact_FX_F select 0);
	}
	else
	{
		if ( (TCL_FX select 2) && { (_ammo isKindOf "ShellBase") } && { (floor (random 100) < (TCL_FX select 3) ) } ) then
		{
			private _shell = _this select 6;
			
			[_shell] spawn (TCL_Whiz_FX_F select 2);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired Advancing
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_weapon","_muzzle"];
	
	if (count (TCL_Advancing select 0) < 5) then
	{
		private _group = (group _unit);
		
		if (_group in (TCL_Advancing select 1) ) exitWith {};
		
		(TCL_Advancing select 1) pushBack _group;
		
		[_group] spawn
		{
			params ["_group"];
			
			sleep 10;
			
			TCL_DeleteAT(TCL_Advancing,1,_group);
		};
		
		private _ammo = _this select 4;
		
		private _distance = [_unit, _weapon, _muzzle, _ammo] call (TCL_Advancing_F select 0);
		
		// player sideChat format ["TCL_EH_Fired_F > Advancing > %1", _distance];
		
		if (_distance > 0) then
		{
			private _array = ( (TCL_Advancing select 0) + (TCL_Reinforcement select 0) );
			
			[_unit, _array, _distance] call (TCL_Feature_F select 2);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Event Handler Fired Suppressed
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit"];
	
	private _time = (_unit getVariable "TCL_Suppressed");
	
	if ( (time - _time) < (TCL_Feature select 28) ) then
	{
		(TCL_Suppressed select 1) pushBack _unit;
		
		if ( { (_x == _unit) } count (TCL_Suppressed select 1) > (TCL_Feature select 29) ) then
		{
			TCL_Suppressed set [1, (TCL_Suppressed select 1) - [_unit] ];
			
			// player sideChat format ["TCL_EH_Fired_F > Suppressed > %1", count (TCL_Suppressed select 1) ];
			
			private _groups = (TCL_Groups select 0);
			
			_groups = _groups - (TCL_Suppressed select 0);
			
			private ["_group","_units"];
			
			private _count = 0;
			
			for "_count" from _count to (count _groups - 1) do
			{
				_group = (_groups select _count);
				
				_units = (units _group);
				
				if (_units findIf { ( (alive _x) && { (isNull objectParent _x) } ) } > -1) then
				{
					[_unit, _group] call (TCL_Suppressed_F select 0);
				};
			};
		};
	}
	else
	{
		_unit setVariable ["TCL_Suppressed", time];
		
		TCL_Suppressed set [1, (TCL_Suppressed select 1) - [_unit] ];
	};
	
	// player sideChat format ["TCL_EH_Fired_F > Suppressed > %1", count (TCL_Suppressed select 1) ];
	
	True
	
	}
];