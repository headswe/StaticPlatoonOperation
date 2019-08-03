if (isServer) then {	
	// Weather
	_date = date;
	_date set [3,selectRandom [5,6,9,12,13,16,17,18]]; // Random hour between 8 and 6pm

	// ====================================================================================

	// SET DATE FOR ALL CLIENTS
	// Using a BIS function we share the new date across the network
	[_date,true,_transition] call BIS_fnc_setDate;
	
	//Random weather
	[] call compile preprocessFile 'functions\weather.sqf';
	 

};

AI_SPAWNED = false;

