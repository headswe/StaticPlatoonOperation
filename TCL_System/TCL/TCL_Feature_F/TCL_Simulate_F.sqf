#include "TCL_Resource.hpp"

TCL_Simulate_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Simulate Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Simulate
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_unit","_object","_array","_animation"];

	_unit = _this select 0;
	_object = _this select 1;

	if ( { (isPlayer _x) } count (units _unit) > 0) exitWith {};

	if ( (alive _unit) && (_unit countEnemy [_object] > 0) && ( [_unit] _call(TCL_Simulate_F,1) ) ) then
	{
		_array = ["AdthPercMstpSlowWrflDnon_1","AdthPercMstpSlowWrflDnon_2","AdthPercMstpSlowWrflDnon_8","AdthPercMstpSlowWrflDnon_16","AdthPercMstpSlowWrflDnon_32","AdthPercMstpSrasWrflDnon_1","AdthPercMstpSrasWrflDnon_2","AdthPercMstpSrasWrflDnon_8","AdthPercMstpSrasWrflDnon_16","AdthPercMstpSrasWrflDnon_32"];

		if ( { (animationState _unit == _x) } count _array > 0) then
		{
			_unit switchMove "AinjPpneMstpSnonWnonDnon_kneel";
		}
		else
		{
			_animation = _array call TCL_Random_F;

			_unit playMove _animation;

			sleep 30 + (random 50);

			if (alive _unit ) then
			{
				if (isMultiplayer) then
				{
					if _getRandom(50) then
					{
						// _unit setVehicleInit "this switchMove ""AinjPpneMstpSnonWnonDnon_rolltofront""; ";

						// processInitCommands;

						_unit playMove "AmovPpneMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
					}
					else
					{
						// _unit setVehicleInit "this switchMove ""AinjPpneMstpSnonWnonDnon_kneel""; ";

						// processInitCommands;
					};

					// clearVehicleInit _unit;
				}
				else
				{
					if _getRandom(50) then
					{
						_unit switchMove "AinjPpneMstpSnonWnonDnon_rolltofront";

						_unit playMove "AmovPpneMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon";
					}
					else
					{
						_unit switchMove "AinjPpneMstpSnonWnonDnon_kneel";
					};
				};
			};
		};
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Simulate Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Simulate
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_unit","_return","_objects","_array","_count","_object"];

	_unit = _this select 0;

	_return = True;

	if (alive _unit) then
	{
		_objects = _unit nearEntities [ ["Man","Car","Tank","Air"], 100];

		_objects = _objects - [_unit];

		if (count _objects > 0) then
		{
			_array = [];

			_count = 0;

			for "_count" from _count to (count _objects - 1) do
			{
				_object = (_objects select _count);

				if ( ( [_object] call TCL_Armed_F) && (_unit countFriendly [_object] > 0) && (side _object != CIVILIAN) && (_unit _getKnows(_object) > 0) ) then
				{
					_setIn(_array,-1,_object);
				};

				if (count _array > _getGlobal(42) ) exitWith
				{
					_return = False;
				};
			};
		};
	};

	_return

	}
];		