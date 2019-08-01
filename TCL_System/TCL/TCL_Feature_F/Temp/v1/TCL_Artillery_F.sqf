TCL_Artillery_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_group","_logic"];
	
	if (TCL_Feature select 9) then
	{
		if (floor (random 100) < (TCL_Feature select 10) ) then
		{
			private _condition = (_logic getVariable "TCL_Artillery");
			
			if (_condition select 0) then
			{
				private _alpha = _group;
				
				private _leader = (leader _alpha);
				
				private _groups = (TCL_Artillery select 0);
				
				_groups = _groups select {_vehicle = (vehicle leader _x); ( (alive _vehicle) && { (canFire _vehicle) } && { (someAmmo _vehicle) } && { (side _alpha getFriend side _x > 0.6) } ) };
				
				if (_groups isEqualTo [] ) exitWith {};
				
				private _distance = (_alpha getVariable "TCL_AI" select 3);
				
				private _position = (getPos _logic);
				
				private ["_bravo","_vehicle","_magazine","_range"];
				
				private _count = 0;
				
				for "_count" from _count to (count _groups - 1) do
				{
					_bravo = (_groups select _count);
					
					_vehicle = (vehicle leader _bravo);
					
					_magazine = (getArtilleryAmmo [_vehicle] select 0);
					
					_range = _position inRangeOfArtillery [crew _vehicle, _magazine];
					
					player sideChat format ["TCL_Artillery_F > Range > %1", _range];
					
					if ( (_vehicle getVariable "TCL_Artillery") && { (_range) } && { (_leader distance _vehicle < _distance) } ) then
					{
						_condition set [0, False];
						
						// _logic setVariable ["TCL_Artillery", False];
						
						_vehicle setVariable ["TCL_Artillery", False];
						
						[_enemy, _logic, _vehicle, _condition] spawn (TCL_Artillery_F select 1);
					};
				};
			};
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_enemy","_logic","_vehicle","_condition"];
	
	private _time = 10 + (random 30);
	
	// _time = _time + (random 50);
	
	player sideChat format ["TCL_Artillery_F > Artillery > %1", _vehicle];
	
	sleep _time;
	
	if ( [_logic, _vehicle] call (TCL_Artillery_F select 2) ) then
	{
		private _bool = False;
		
		if (TCL_Sound) then
		{
			_bool = True;
		};
		
		_condition set [1, True];
		
		_vehicle doWatch (getPos _logic);
		
		sleep 5 + (random 10);
		
		private _magazine = (getArtilleryAmmo [_vehicle] select 0);
		
		private _ammo = getText (configfile >> "CfgMagazines" >> _magazine >> "ammo");
		
		private _count = 3 + (random 5);
		
		_vehicle doArtilleryFire [ (getPos _logic), _magazine, _count];
		
		if (True) exitWith {};
		
		while { (_count > 0) } do
		{
			_vehicle doArtilleryFire [ (getPos _logic), _magazine, _count];
			
			_count = _count - 1;
			
			sleep 3 + (random 5);
		};
		
		if (True) exitWith {};
		
		if ( (_vehicle isKindOf "Tank") && { (isNull objectParent _enemy) } ) then
		{
			// _ammo = "Sh_82mm_AMOS";
		};
		
		// _ammo = "Sh_155mm_AMOS";
		
		// _ammo = "Cluster_155mm_AMOS";
		
		private _range = 30;
		
		private	_random = (random 50);
		
		private	_distance = (_range + _random);
		
		private _position = (getPos _logic);
		
		private ["_random","_distance","_shell"];
		
		private _count = 7 + (random 10);
		
		while { (_count > 0) } do
		{
			private	_random = (random 30);
			
			private	_distance = (_range + _random);
		
			_shell = _ammo createVehicle [ (_position select 0) + (random _distance - random _distance), (_position select 1) + (random _distance - random _distance), 100];
			
			if (_bool) then
			{
				if (floor (random 100) < (TCL_FX select 3) ) then
				{
					if (TCL_Multiplayer) then
					{
						TCL_Public = [_shell];
						
						publicVariable "TCL_Public";
						
						if (TCL_Dedicated) exitWith {};
						
						[_shell] spawn (TCL_Whiz_FX_F select 2);
					}
					else
					{
						[_shell] spawn (TCL_Whiz_FX_F select 2);
					};
				};
			};
			
			_shell setVelocity [0,0,-100];
			
			sleep 3 + (random 5);
			
			_count = _count - 1;
		};
		
		_condition set [1, False];
		
		sleep 5 + (random 10);
		
		_vehicle doWatch objNull;
		
		sleep 150 + (random 170);
	}
	else
	{
		sleep 30 + (random 50);
	};
	
	_condition set [0, True];
	
	_vehicle setVariable ["TCL_Artillery", True];
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_logic","_vehicle"];
	
	private _return = True;
	
	private _objects = _logic nearEntities [ ["CAManBase","Car","Tank","Helicopter"], 100];
	
	if (_objects isEqualTo [] ) exitWith {_return};
	
	private "_object";
	
	private _count = 0;
	
	for "_count" from _count to (count _objects - 1) do
	{
		_object = (_objects select _count);
		
		if ( (alive _object) && { (side _object getFriend side _vehicle > 0.6) } ) exitWith
		{
			_return = False;
		};
	};
	
	_return
	
	}
];