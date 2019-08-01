TCL_Explosion_FX_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Explosion FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Explosion FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle"];
	
	private _size = (sizeOf typeOf _vehicle);
	
	[_vehicle, _size] call (TCL_Flash_FX_F select 0);
	
	[_vehicle, _size] call (TCL_Flash_FX_F select 1);
	
	[_vehicle, _size] call (TCL_Shard_FX_F select 0);
	
	private _detector = objNull;
	
	if (TCL_Sound) then
	{
		_detector = "EmptyDetector" createVehicleLocal (getPos _vehicle);
		
		private _sound = (TCL_Resource select 14) call TCL_Random_F;
		
		private _distance = (_size * 50);
		
		_detector say [_sound, _distance];
	};
	
	while { (getPos _vehicle select 2 > 3) } do
	{
		sleep 1;
	};
	
	if (surfaceIsWater getPos _vehicle) exitWith {};
	
	[_vehicle, _size] call (TCL_Dust_FX_F select 0);
	
	[_vehicle, _size] spawn (TCL_Mud_FX_F select 0);
	
	[_vehicle, _size] spawn (TCL_Dirt_FX_F select 0);
	
	[_vehicle, _size] spawn (TCL_Stone_FX_F select 0);
	
	// [_vehicle, _size] spawn (TCL_Smoke_FX_F select 0);
	
	if (alive _detector) then
	{
		sleep 5;
		
		deleteVehicle _detector;
	};
	
	}
];