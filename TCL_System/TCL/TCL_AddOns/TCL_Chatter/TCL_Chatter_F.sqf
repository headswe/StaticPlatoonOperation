#include "TCL_Resource.hpp"

TCL_Chatter_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Chatter Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Chatter
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_vehicle","_sounds","_delays","_count","_sound","_delay"];

	_vehicle = _this select 0;

	if _getRandom(50) then
	{
		_sounds = ["West_Air_v56a","West_Air_v57a","West_Air_v58a","West_Air_v59a","West_Air_v60a","West_Air_v61a","West_Air_v62a","West_Air_v63a","West_Air_v64a","West_Air_v65a","West_Air_v66a","West_Air_v67a","West_Air_v68a","West_Air_v69a","West_Air_v70a","West_Air_v71a","West_Air_v72a","West_Air_v73a","West_Air_v74a","West_Air_v75a","West_Air_v76a","West_Air_v77a","West_Air_v78a","West_Air_v79a","West_Air_v80a","West_Air_v81a","West_Air_v82a","West_Air_v83a"];

		_delays = [4.76, 3.4, 2.12, 2.56, 4.76, 1.5, 4.84, 2.16, 2.48, 4.4, 5.56, 2.36, 1.92, 2.72, 3.48, 5.56, 2.72, 2.92, 1.92, 2.24, 5.36, 4.36, 5.32, 4.48, 4.32, 5.12, 3.76, 10.96];
	}
	else
	{
		_sounds = ["West_Air_v84a","West_Air_v85a","West_Air_v86a","West_Air_v87a","West_Air_v88a","West_Air_v89a","West_Air_v90a","West_Air_v91a","West_Air_v92a","West_Air_v93a","West_Air_v94a","West_Air_v95a","West_Air_v96a"];

		_delays = [2.24, 5.6, 11.3, 2.6, 2.12, 1.5, 2.84, 4.56, 3.72, 4.8, 3.84, 5.2, 3.2];
	};

	_count = 0;

	while { ( (alive _vehicle) && { (_vehicle == vehicle player) } && { (isEngineOn _vehicle) } && { (_count < count _sounds) } && { (TCL_Chatter select 0) } ) } do
	{
		0 fadeMusic (TCL_Chatter select 1);

		_sound = (_sounds select _count);

		playMusic _sound;

		_delay = (_delays select _count);

		sleep _delay;

		_count = _count + 1;
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Chatter Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Chatter
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_key","_vehicle","_volume"];

	_key = _this select 1;
	
	_vehicle = (vehicle player);

	if ( ( (_vehicle isKindOf "Car") || (_vehicle isKindOf "Tank") || (_vehicle isKindOf "Air") ) && { (isEngineOn _vehicle) } ) then
	{
		if ( (_key == (TCL_FX select 9) ) && ( (TCL_Chatter select 2) != 10) ) exitWith
		{
			_volume = (TCL_Chatter select 2);

			_volume = _volume + 1;

			if (_volume >= 10) then
			{
				_volume = 10;
			};

			[_vehicle, _volume, False] call (TCL_Chatter_F select 2);
		};

		if ( (_key == (TCL_FX select 10) ) && ( (TCL_Chatter select 2) != 0) ) exitWith
		{
			_volume = (TCL_Chatter select 2);

			_volume = _volume - 1;

			if (_volume <= 0) then
			{
				_volume = 0;
			};

			[_vehicle, _volume, False] call (TCL_Chatter_F select 2);
		};
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Chatter Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Chatter
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_vehicle","_volume","_type","_displayName","_value","_count","_status","_string"];

	_vehicle = _this select 0;
	_volume = _this select 1;
	_type = _this select 2;

	_displayName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");

	if (_volume > 0) then
	{
		_value = "";

		_count = 0;

		for "_count" from _count to (_volume - 1) do
		{
			_value = _value + "|";
		};

		TCL_Chatter set [0, True];

		TCL_Chatter set [1, (_volume / 10) ];
	}
	else
	{
		_value = "Disabled";

		TCL_Chatter set [0, False];

		TCL_Chatter set [1, _volume];
	};

	TCL_Chatter set [2, _volume];

	[_type, _displayName, _value] spawn
	{
		_text =
		{
			parseText format ["<t color='#ffff00' size='1.5'>Radio Chatter</t><br/>%1 <t color='#32cd32' size='1.5'>%2</t>", _this, _status];
		};

		if (_this select 0) then
		{
			_status = "Enabled";

			_string = (_this select 1) call _text;

			hint _string;

			sleep 3;
		};

		_status = (_this select 2);

		_string = (_this select 1) call _text;

		hint _string;
	};

	True;

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Chatter Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Chatter
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_vehicle","_volume"];

	_vehicle = _this select 0;

	if (_vehicle != vehicle player) then
	{
		_volume = (TCL_Chatter select 1);

		while { (_volume > 0) } do
		{
			_volume = _volume - 0.1;

			0 fadeMusic _volume;

			sleep 0.1;
		};

		sleep 1;

		playMusic "";

		hint "";

		0 fadeMusic 0.5;
	};

	_vehicle = (vehicle player);

	_vehicle

	}
];					