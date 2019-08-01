#include "TCL_Macros.hpp"

TCL_Watch_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Watch Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Watch
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_group"];
	
	private _units = (units _group);
	
	_units = _units - (TCL_Watch select 0);
	
	if (_units isEqualTo [] ) exitWith {};
	
	private _unit = _units select random (count _units - 1);
	
	if (isNull objectParent _unit) then
	{
		private _velocity = [_unit] call TCL_Velocity_F;
		
		if (_velocity < 1) then
		{
			(TCL_Watch select 0) pushBack _unit;
			
			private _range = (random 180);
			
			private _direction = (getDir _unit - _range);
			
			if (_direction < 0) then
			{
				_direction = _direction + 360;
			};
			
			private _distance = 50;
			
			private _random = (random 70);
			
			_distance = (_distance + _random);
			
			private _position = [ (getPos _unit select 0) + sin (_direction * _distance), (getPos _unit select 1) + cos (_direction * _distance), 1 + (random 1) ];
			
			// private _spot = "Land_HelipadCircle_F" createVehicleLocal _position;
			
			_unit doWatch _position;
			
			if (floor (random 100) < 50) then
			{
				if (_unit hasWeapon "Binocular") then {_unit selectWeapon "Binocular"};
			};
			
			sleep 10 + (random 30);
			
			// _unit playMove "Acts_AidlPercMstpSlowWrflDnon_pissing";
			
			if (_group in (TCL_Reinforcement select 0) ) then
			{
				_unit = _unit;
			}
			else
			{
				_unit doWatch objNull;
				
				// sleep 10 + (random 30);
			};
			
			if (currentWeapon _unit isEqualTo "Binocular") then
			{
				_unit selectWeapon (primaryWeapon _unit);
			};
			
			// deleteVehicle _spot;
			
			TCL_DeleteAT(TCL_Watch,0,_unit);
		};
	};
	
	}
];