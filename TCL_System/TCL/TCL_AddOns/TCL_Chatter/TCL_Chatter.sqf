// ////////////////////////////////////////////////////////////////////////////
// TCL v.1.0
// ////////////////////////////////////////////////////////////////////////////
// Radio Chatter
// Script by =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////
private ["_index","_vehicle","_turrets","_side","_string","_delay"];

// call compile preprocessFileLineNumbers (TCL_Path+"TCL\TCL_Database\TCL_Radio.sqf");

#define _define1 30 - (random 30); while { ( (_delay > 0) && (_vehicle == vehicle player) ) } do {_delay = _delay - 1; sleep 1}; _vehicle = [_vehicle] call (TCL_Chatter_F select 3)

#include "TCL_Resource.hpp"

_isAir =
{
	( (_vehicle isKindOf "Air") && (isEngineOn _vehicle) && (TCL_Chatter select 0) && (_side == 1) )
};

_isLand =
{
	( ( (_vehicle isKindOf "Car") || (_vehicle isKindOf "Tank") ) && { (count _turrets > 0) } && { (isEngineOn _vehicle) } && { (TCL_Chatter select 0) } )
};

waitUntil { !(isNull (finddisplay 46) ) };

_index = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call (TCL_Chatter_F select 1)"];

while { (TCL_FX select 6) } do
{
	if (player != vehicle player) then
	{
		_vehicle = (vehicle player);
		
		_turrets = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "turrets");
		
		_side = getNumber (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "side");
		
		switch (True) do
		{
			case (call _isAir) :
			{
				[_vehicle, (TCL_Chatter select 2), True] call (TCL_Chatter_F select 2);
				
				while { (call _isAir) } do
				{
					if (floor (random 100) < 75) then
					{
						0 fadeMusic (TCL_Chatter select 1);

						_string = ( (TCL_Resource select 2) + (TCL_Resource select 5) ) call TCL_Random_F;

						playMusic _string;
					}
					else
					{
						[_vehicle] call (TCL_Chatter_F select 0);
					};

					_delay = _define1;
				};
			};

			case (call _isLand) :
			{
				[_vehicle, (TCL_Chatter select 2), True] call (TCL_Chatter_F select 2);

				while { (call _isLand) } do
				{
					0 fadeMusic (TCL_Chatter select 1);

					switch (_side) do
					{
						case 0 :
						{
							_string = (TCL_Resource select 4) call TCL_Random_F;
						};

						case 1 :
						{
							_string = ( (TCL_Resource select 3) + (TCL_Resource select 5) ) call TCL_Random_F;
						};

						case 2 :
						{
							_string = (TCL_Resource select 4) call TCL_Random_F;
						};
					};

					playMusic _string;

					_delay = _define1;
				};
			};
		};
	};

	sleep 5;
};

(findDisplay 46) displayRemoveEventHandler ["KeyDown", _index];