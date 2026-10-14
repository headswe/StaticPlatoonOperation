if (isServer) then {	
	// Weather
	private _date = date;
	_date set [3,selectRandom [5,6,9,12,13,16,17,18]]; // Random hour between 05:00 and 18:00

	// ====================================================================================

	// SET DATE FOR ALL CLIENTS
	// Using a BIS function we share the new date across the network
	[_date,true] call BIS_fnc_setDate;
	
	//Random weather
	[] call compile preprocessFileLineNumbers 'functions\weather.sqf';
	 

};

spo_aiSpawned = false;

