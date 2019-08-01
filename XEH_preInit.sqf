if (isServer) then {
    if (isNil "f_paramsArray_complete") then {
        if (isNil "paramsArray") then {
            {
                _paramName = (configName _x);
                _paramValue = (getNumber (missionConfigFile >> "Params" >> _paramName >> "default"));
                missionNamespace setVariable[_paramName,_paramValue];
                publicVariable _paramName;
            } forEach ("true" configClasses (missionConfigFile >> "Params"));
        } else {
            {
                _paramName =(configName ((missionConfigFile >> "Params") select _forEachIndex));
				missionNamespace setVariable[_paramName,_x];
				publicVariable _paramName;
            } forEach paramsArray;
            f_ParamsArray_complete = true;
        };
    };
	private _values = ['values'] call compile preprocessFile 'macro.sqf';


	
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

