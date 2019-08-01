#define TCL_DeleteAT(_array, _index, _object); (_array select _index) deleteAt ( (_array select _index) find _object);

TCL_Whiz_FX_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_bullet"];
	
	private _direction = [_unit, player] call TCL_Rel_Dir_To_F;
	
	if ( (_direction > 340) || (_direction < 20) ) then
	{
		(TCL_Whiz_FX select 0) pushBack _bullet;
		
		private _array = (TCL_Whiz_FX select 1);
		
		private _detector = (_array select 0);
		
		TCL_DeleteAT(TCL_Whiz_FX,1,_detector);
		
		[_bullet, _detector] spawn (TCL_Whiz_FX_F select 1);
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_bullet","_detector"];
	
	if (alive _bullet) then
	{
		private _sound = (TCL_Resource select 0) call TCL_Random_F;
		
		private _random = 1 + (random 3);
		
		_detector say3D [_sound, 100, _random];
		
		private _time = (time + 1);
		
		while { ( (alive _bullet) && { (time < _time) } ) } do
		{
			_detector setPos (getPos _bullet);
			
			sleep 0.01;
		};
		
		_detector setPos [0,0,0];
	};
	
	TCL_DeleteAT(TCL_Whiz_FX,0,_bullet);
	
	(TCL_Whiz_FX select 1) pushBack _detector;
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Whiz FX
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_shell"];
	
	private _detector = "EmptyDetector" createVehicleLocal (getPos _shell);
	
	private _sound = (TCL_Resource select 1) call TCL_Random_F;
	
	_detector say3D [_sound, 300];
	
	private _time = (time + 1);
	
	while { ( (alive _shell) && { (time < _time) } ) } do
	{
		_detector setPos (getPos _shell);
		
		sleep 0.01;
	};
	
	deleteVehicle _detector;
	
	}
];