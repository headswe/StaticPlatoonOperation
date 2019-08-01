TCL_Dirt_FX_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Dirt FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Dirt FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_vehicle","_size"];
	
	if (isOnRoad _vehicle) exitWith {};
	
	private "_random";
	
	private _count = (_size + random _size);
	
	while { (_count > 0) } do
	{
		_random = [0.5 + (random 0.7), [ (random 10 - random 10), (random 10 - random 10), 5 + (random 7) ], [0.3 + random 0.7, 0.7 - random 0.3] ];
		
		drop [ ["\A3\Data_F\ParticleEffects\Universal\Universal.p3d", 16, 12, 9, 0], "", "Billboard", 0.05, (_random select 0),
		
		[0,0,-1], (_random select 1), 0, 1, 0, 0,
		
		(_random select 2), [ [0.1,0.1,0.1,1],[0.1,0.1,0.1,0.5],[0.1,0.1,0.1,0.3] ], [1],
		
		1, 1, (TCL_Path+"TCL\TCL_AddOns\TCL_FX_F\TCL_Dirt_FX.sqf"), "", _vehicle, random 360];
		
		_count = _count - 3;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Dirt FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Dirt FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{
	
	drop [ ["\A3\Data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 9, 0], "", "Billboard", 10, 1,
	
	_this, [0,0,0], 0, 1.5, 1, 0,
	
	[1 + random 1, 1 - random 1], [ [0.1,0.1,0.1,1],[0.1,0.1,0.1,0] ], [1000], 0, 0, "", "", ""];
	
	}
];
