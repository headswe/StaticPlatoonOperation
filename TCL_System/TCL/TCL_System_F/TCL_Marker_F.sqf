TCL_Marker_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Marker Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Marker
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type"];
	
	if (_type isEqualType "") then
	{
		if (TCL_Debug select 1) then
		{
			_this call (TCL_Marker_F select 1);
		};
	}
	else
	{
		if (TCL_Debug select 2) then
		{
			_this spawn (TCL_Marker_F select 2);
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Marker Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Marker
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_type","_object","_group","_logic"];
	
	if (True) then
	{
		if (_type isEqualTo "TCL_Logic") exitWith
		{
			private _logic = _object;
			
			private _marker = [ [_type, _logic], (getPos _logic), "Icon", [1,1], "selector_selectedMission", "colorRed"] call TCL_Create_Marker_F;
		};
		
		if (_type isEqualTo "TCL_KnowsAbout") exitWith
		{
			private _marker = format ["%1%2", "TCL_Logic", _logic];
			
			private _position = (getPos _logic);
			
			_position set [1, (_position select 1) + 30];
			
			_marker setMarkerPos _position;
			
			if (alive _object) then
			{
				private _value = (_group knowsAbout vehicle _object);
				
				[_marker, _value] spawn
				{
					params ["_marker","_value"];
					
					if (_value > 0) then
					{
						_value = (_value * 3);
						
						while { (_value > 0) } do
						{
							_marker setMarkerDir (markerDir _marker) + 30;
							
							// _marker setMarkerSize [_value, _value];
							
							_value = _value - 1;
							
							sleep 1;
						};
					};
				};	
			};
		};
		
		if (_type isEqualTo "TCL_Spot") exitWith
		{
			private _enemy = _object;
			
			private _marker = format ["%1%2", "TCL_Logic", _logic];
			
			private _time = (_logic getVariable "TCL_Time");
			
			_time = (_time - time);
			
			private "_string";
			
			private _color = "colorGreen";
			
			private _knowsAbout = (_group knowsAbout vehicle _enemy);
			
			private _groups = (_logic getVariable "TCL_Reinforcement");
			
			private _bool = [_enemy, _groups] call TCL_Knowledge_F;
			
			if (_bool) then
			{
				_color = "colorRed";
				
				_string = format ["%1 > %2 > %3 > %4 %5 > %6", group _enemy, _group, _group knowsAbout vehicle _enemy, round (leader _group distance _enemy), _groups, round _time];
			}
			else
			{
				if (alive _enemy) then
				{
					_color = "colorGreen";
					
					_string = format ["%1 > %2 > %3 > %4", "Unknown", _group, _groups, round _time];
				}
				else
				{
					_color = "colorWhite";
					
					_string = format ["%1 > %2 > %3 > %4", "Killed", _group, _groups, round _time];
				};
			};
			
			_marker setMarkerColor _color;
			
			_marker setMarkerText _string;
		};
		
		if (_type isEqualTo "TCL_Enemy") exitWith
		{
			private _enemy = _object;
			
			private _marker = [ [_type, _group], (getPos _logic), "ELLIPSE", [100,100], "FDiagonal", "colorRed"] call TCL_Create_Marker_F;
			
			if (_marker isEqualTo "") exitWith {};
			
			private _position = (getPos _logic);
			
			private _array = (_logic getVariable "TCL_Reinforcement");
			
			private _index = (_array find _group);
			
			_index = _index + 1;
			
			private _value = (30 * _index);
			
			_position set [1, (_position select 1) - _value];
			
			private _leader = (leader _group);
			
			private _text = [ [_type, (name _leader) ], _position, "Icon", [1,1], "mil_dot", "colorRed"] call TCL_Create_Marker_F;
			
			_text setMarkerText format ["%1 > %2 > %3 > %4", _group, _enemy, (_group knowsAbout vehicle _enemy), round (_leader distance _enemy) ];
			
			private "_string";
			
			private _color = "colorGreen";
			
			private _knowsAbout = (_group knowsAbout vehicle _enemy);
			
			private _groups = (_logic getVariable "TCL_Reinforcement");
			
			private _bool = [_enemy, _groups] call TCL_Knowledge_F;
			
			if (_bool) then
			{
				_object = "Unknown";
				
				if (_knowsAbout > 0) then
				{
					_object	= _enemy;
					
					_color = "colorRed";
				};
				
				 _string = format ["%1 > %2 > %3 > %4", _group, _object, (_group knowsAbout vehicle _enemy), round (_leader distance _enemy) ];
			}
			else
			{
				if (alive _enemy) then
				{
					_color = "colorGreen";
					
					_string = format ["%1 > %2 > %3 > %4", _group, "Unknown", (_group knowsAbout vehicle _enemy), round (_leader distance _enemy) ];
				}
				else
				{
					_color = "colorWhite";
					
					_string = format ["%1 > %2 > %3 > %4", _group, "Killed", (_group knowsAbout vehicle _enemy), round (_leader distance _enemy) ];
				};
			};
			
			_text setMarkerColor _color;
			
			_text setMarkerText _string;
			
			_marker setMarkerColor _color;
			
			if (_knowsAbout < 1) then
			{
				_knowsAbout = 1;
			};
			
			[_marker, _text, _knowsAbout] spawn
			{
				params ["_marker","_text","_knowsAbout"];
				
				private _size = 70;
				
				_size = (_size * _knowsAbout);
				
				while { (_size > 0) } do
				{
					_marker setMarkerSize [_size, _size];
					
					_marker setMarkerDir (markerDir _marker) + _size;
					
					_size = _size - 10;
					
					sleep 0.1;
				};
				
				deleteMarker _text;
				
				deleteMarker _marker;
			};
		};
		
		if (_type isEqualTo "TCL_Position") exitWith
		{
			private _group = _object;
			
			if (count _this == 3) then
			{
				private _position = _this select 2;
				
				private _enemy = (_group getVariable "TCL_Enemy");
				
				// private _enemy = (leader _group findNearestEnemy leader _group);
				
				private _marker = [ [_type, _group], _position, "Icon", [1,1], "mil_dot", "colorWhite"] call TCL_Create_Marker_F;
				
				if (_marker isEqualTo "") then
				{
					_marker = format ["%1%2", _type, _group];
					
					_marker setMarkerPos _position;
				};
				
				_marker setMarkerText format ["%1 %2 %3", _group, (_group knowsAbout vehicle _enemy), round (leader _group distance _position) ];
			}
			else
			{
				private _marker = format ["%1%2", _type, _group];
				
				deleteMarker _marker;
			};
		};
		
		if (_type isEqualTo "TCL_Remount") exitWith
		{
			private _group = _object;
			
			if (count _this == 2) then
			{
				private _marker = format ["%1%2", "TCL_Position", _group];
				
				private _position = (_group getVariable "TCL_Position");
				
				_marker setMarkerPos _position;
				
				private _ai = (_group getVariable "TCL_AI");
				
				_marker setMarkerText format ["%1 %2", _group, _ai];
			}
			else
			{
				private _vehicle = _this select 2;
				
				private _marker = [ [_type, _group, _vehicle], (getPos _vehicle), "Icon", [1,1], "mil_dot", "colorWhite"] call TCL_Create_Marker_F;
				
				if (_marker isEqualTo "") exitWith {};
				
				private _displayName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
				
				_marker setMarkerText format ["%1 ( %2 )", _group, _displayName];
				
				[_group, _vehicle, _marker] spawn
				{
					params ["_group","_vehicle","_marker"];
					
					while { ( (_group in (TCL_Remount select 0) ) && (units _group findIf { ( (isNull objectParent _x) && (assignedVehicle _x == _vehicle) ) } > -1) ) } do
					{
						sleep 1;
					};
					
					deleteMarker _marker;
				};
			};
		};
		
		if (_type isEqualTo "TCL_Marker") exitWith
		{
			private _group = _object;
			
			private _trigger = _this select 2;
			
			private _area = (triggerArea _trigger);
			
			private _shape = "ELLIPSE";
			
			if (_area select 3) then
			{
				_shape = "RECTANGLE";
			};
			
			private _position = (getPos _trigger);
			
			private _brush = [ [_type, _position], _position, _shape, [ (_area select 0), (_area select 1) ], "Horizontal", "colorGreen"] call TCL_Create_Marker_F;
			
			private _border = [ [_type, _position, _area], _position, _shape, [ (_area select 0), (_area select 1) ], "Border", "colorGreen"] call TCL_Create_Marker_F;
			
			_brush setMarkerDir + (_area select 2);
			
			_border setMarkerDir + (_area select 2);
			
			[_group, _trigger, _brush, _border, _area] spawn
			{
				params ["_group","_trigger","_brush","_border","_area"];
				
				private ["_enemy","_area0","_area1"];
				
				while { (units _group findIf { (alive _x) } > -1) } do
				{
					_brush setMarkerColor "colorGreen";
					
					_enemy = (_group getVariable "TCL_Enemy");
					
					// _enemy = (leader _group findNearestEnemy leader _group);
					
					if (alive _enemy) then
					{
						if (_enemy inArea _trigger) then
						{
							_brush setMarkerColor "colorRed";
						};
					};
					
					_area0 = (_area select 0);
					_area1 = (_area select 1);
					
					while { ( (_area0 > 0) && (_area1 > 0) ) } do
					{
						_brush setMarkerSize [_area0, _area1];
						
						_area0 = (_area0 - 10);
						_area1 = (_area1 - 10);
						
						sleep 0.3;
					};
				};
				
				deleteMarker _brush;
				deleteMarker _border;
			};
		};
		
		if (_type isEqualTo "TCL_Delete") exitWith
		{
			private _logic = _object;
			
			private _marker = format ["%1%2", "TCL_Logic", _logic];
			
			deleteMarker _marker;
		};
	};
	
	True
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Marker Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Marker
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit"];
	
	private _type = nil;
	
	private _side = (side _unit);
	
	if (TCL_Debug select 3) then {_type = _unit} else {if (_unit == leader _unit) then {_type = (group _unit) } };
	
	if (isNil "_type") exitWith {};
	
	private _marker = [ [_type, time], (getPos _unit), "Icon", [1,1], "mil_triangle", "colorYellow"] call TCL_Create_Marker_F;
	
	private _array = (TCL_Players select 0);
	
	if (_unit in _array) exitWith
	{
		[_unit, _marker] spawn (TCL_Marker_F select 3);
	};
	
	private ["_group","_color","_vehicle","_displayName","_unitType","_groupType","_array","_enemy","_string"];
	
	while { (alive _unit) } do
	{
		if ( (visibleMap) || (TCL_Multiplayer) ) then
		{
			_group = (group _unit);
			
			if (leader _unit in _array) exitWith
			{
				_type = "A.I.";
				
				_marker setMarkerPos (getPos _unit);
				
				_marker setMarkerDir (getDir _unit);
				
				_marker setMarkerText format ["%1 ( %2 ) %3", _unit, _side, _type];
			};
			
			if (_group in (TCL_Disabled select 0) ) exitWith
			{
				_unit = objNull;
			};
			
			if (TCL_Debug select 3) then
			{
				if (_marker isEqualTo format ["%1", _unit] ) then
				{
					// _unit = _unit;
				}
				else
				{
					// [_unit] spawn (TCL_Marker_F select 2);
					
					// player sideChat format ["TCL_Marker_F > Changed > %1", _unit];
					
					// _unit = objNull;
				};
			};
			
			_color = "colorYellow";
			
			if (True) then
			{
				_unitType = "I.D.L.E.";
				
				if (fleeing _unit) exitWith
				{
					_unitType = "Fleeing"; _color = "colorWhite";
				};
				
				if (captive _unit) exitWith
				{
					_unitType = "Captive"; _color = "colorWhite";
				};
				
				if (side _unit == CIVILIAN) exitWith
				{
					_unitType = "Civilian"; _color = "colorWhite";
				};
				
				if (_group in (TCL_Artillery select 0) ) exitWith
				{
					_unitType = "Artillery"; _color = "colorGreen";
				};
				
				if (_unit in (TCL_Heal select 0) ) exitWith
				{
					_unitType = "( Heal )"; _color = "colorGreen";
				};
				
				if (_unit in (TCL_Rearm select 0) ) exitWith
				{
					_unitType = "( Rearm )"; _color = "colorGreen";
				};
				
				if (_unit in (TCL_Static_Weapon select 0) ) exitWith
				{
					_unitType = "( Static Weapon )"; _color = "colorGreen";
				};
				
				if (_unit in (TCL_House_Search select 0) ) exitWith
				{
					_unitType = "( House Search )"; _color = "colorGreen";
				};
				
				if (_group in (TCL_Suppressed select 0) ) exitWith
				{
					_unitType = "( Suppressed )"; _color = "colorGreen";
				};
				
				if (_unit in (TCL_Take_Cover select 0) ) exitWith
				{
					_unitType = "( Take Cover )"; _color = "colorGreen";
					
					if (_unit in (TCL_Flanking select 1) ) exitWith
					{
						_unitType = "( Flanking )"; _color = "colorGreen";
					};
					
					if (_unit in (TCL_Flanking select 2) ) exitWith
					{
						_unitType = "( Flanking )"; _color = "colorBlue";
					};
				};
				
				if (_unit in (TCL_Regroup select 0) ) exitWith
				{
					_unitType = "( Regroup )"; _color = "ColorBlue";
				};
				
				if (_group in (TCL_Advancing select 0) ) exitWith
				{
					_unitType = "Advancing";
				};
				
				if (_group in (TCL_Zeus select 1) ) exitWith
				{
					_unitType = "Zeus";
				};
				
				if (_group in (TCL_Behaviour select 0) ) exitWith
				{
					_unitType = "Behaviour";
				};
				
				if (_group in (TCL_Waiting select 0) ) exitWith
				{
					_unitType = "Waiting";
				};
				
				if (_group in (TCL_Sneaking select 0) ) exitWith
				{
					_unitType = "Sneaking";
				};
				
				if (_group in (TCL_Join select 0) ) exitWith
				{
					_unitType = "Joined";
				};
				
				if (_group in (TCL_Enhanced select 0) ) exitWith
				{
					_unitType = "Enhanced";
				};
				
				if (_group in (TCL_Freeze select 0) ) exitWith
				{
					_unitType = "Freeze";
				};
				
				if (_group in (TCL_Default select 0) ) exitWith
				{
					_unitType = "Default";
				};
				
				if (_group in (TCL_Reinforcement select 1) ) exitWith
				{
					_unitType = "Reinforcement";
				};
				
				if (_group in (TCL_Reinforcement select 0) ) exitWith
				{
					if (_group in (TCL_Request select 0) ) then
					{
						_unitType = "Request";
					}
					else
					{
						_unitType = "Requested";
					};
				};
				
				if (_unit in (TCL_Watch select 0) ) exitWith
				{
					_unitType = "( Watch )"; _color = "colorGreen";
				};
				
				if (_group in (TCL_Garrison select 0) ) exitWith
				{
					_unitType = "Garrison";
				};
			};
			
			if (True) then
			{
				_groupType = "Combat";
				
				if (_group in (TCL_Location select 0) ) exitWith
				{
					private _string = ["Location"]; _color = "colorGreen";
					
					_array = (_group getVariable "TCL_Location");
					
					_array = _array - [_group];
					
					if (count _array > 0) then
					{
						private _count = (count _array);
						
						_string pushBack format ["%1", _count];
					};
					
					if (_group in (TCL_Hold select 0) ) then
					{
						_string pushBack "Hold";
						
						_color = "colorGreen";
					};
					
					if (_group in (TCL_Defend select 0) ) then
					{
						_string pushBack "Defend";
								
						_color = "colorGreen";
					};
					
					_groupType = _string joinString " > ";
				};
				
				if (_group in (TCL_Hold select 0) ) exitWith
				{
					_groupType = "Hold"; _color = "colorGreen";
				};
				
				if (_group in (TCL_Defend select 0) ) exitWith
				{
					_groupType = "Defend"; _color = "colorGreen";
				};
				
				if (_group in (TCL_Custom select 0) ) exitWith
				{
					_groupType = "Custom";
				};
			};
			
			if (_unit == leader _unit) then
			{
				_color = "colorRed";
			};
			
			_enemy = (_group getVariable "TCL_Enemy");
			
			if ( (alive _enemy) && (_unit knowsAbout vehicle _enemy > 0) ) then
			{
				_enemy = _enemy;
			}
			else
			{
				_enemy = "Unknown";
			};
			
			_markerText = _marker;
			
			if (isNull objectParent _unit) then
			{
				_displayName = "";
			}
			else
			{
				_vehicle = (vehicle _unit);
				
				if (_unit == driver _vehicle) then
				{
					_color = "colorWhite";
				}
				else
				{
					if (_unit == commander _vehicle) then
					{
						_color = "colorBlue";
					}
					else
					{
						if (_unit == gunner _vehicle) then
						{
							_color = "colorGreen";
						};
					};
				};
				
				_displayName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			};
			
			if (_markerText isEqualTo "") then
			{
				_marker setMarkerText _markerText;
			}
			else
			{
				if (_unit == leader _unit) then
				{
					_string = format ["%1 %2 %3 %4 ( %5 %6 %7 %8 ) %9 %10 %11", _unitType, _groupType, _side, _unit, (behaviour _unit), (combatMode _unit), (speedMode _unit), (formation _unit), _enemy, (assignedTarget _unit), (unitPos _unit) ];
				}
				else
				{
					_string = format ["%1 %2 %3 %4 %5 %6", _unitType, _side, _unit, _enemy, (assignedTarget _unit), (unitPos _unit) ];
				};
				
				if (currentCommand _unit isEqualTo "") then
				{
					_string = _string + format [" %1", _displayName];
				}
				else
				{
					_string = _string + format [" %1 %2", (currentCommand _unit), _displayName];
				};
				
				if (False) then
				{
					if (_unit == leader _unit) then
					{
						_string = format ["%1 %2 %3 %4 ( %5 %6 %7 %8 )", _unitType, _groupType, _side, _unit, (behaviour _unit), (combatMode _unit), (speedMode _unit), (formation _unit) ];
					}
					else
					{
						_string = format ["%1 %2 %3 %4", _unitType, _side, _unit];
					};
					
					_string = _string + format ["> %1", (expectedDestination _unit) ];
					
					if (currentCommand _unit isEqualTo "") exitWith {};
					
					_string = _string + format [" %1 > %2", (unitPos _unit), (currentCommand _unit) ];
				};
				
				if (unitReady _unit) then
				{
					_string = _string + " > Ready";
				};
				
				_marker setMarkerText _string;
			};
			
			_marker setMarkerDir (getDir _unit);
			
			if (False) then
			{
			
			_color = "colorWhite";
			
			if (side _unit == EAST) then
			{
				_color = "colorRed";
			}
			else
			{
				if (side _unit == WEST) then
				{
					_color = "colorBlue";
				}
				else
				{
					if (side _unit == RESISTANCE) then
					{
						_color = "colorGreen";
					};
				};
			};
			
			if (_unit == leader _unit) then
			{
				_color = "colorYellow";
			};
			
			};
			
			_marker setMarkerColor _color;
			
			_marker setMarkerPos (getPos _unit);
		};
		
		sleep 1;
	};
	
	_marker setMarkerColor "colorGrey";
	
	_marker setMarkerText format ["%1 %2 ( %3:%4 )", _unit, _side, floor (time / 60), round (time % 60) ];
	
	if (_type isEqualType grpNull) then
	{
		{ [_x] spawn (TCL_Marker_F select 2) } forEach units _unit;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Marker Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Marker
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_marker"];
	
	private _side = (side _unit);
	
	_marker setMarkerColor "colorBlue";
	
	private ["_type","_vehicle","_displayName"];
	
	while { (alive _unit) } do
	{
		if ( (visibleMap) || (TCL_Multiplayer) ) then
		{
			if (TCL_Debug select 3) then
			{
				if (_marker isEqualTo format ["%1", _unit] ) then
				{
					_unit = _unit;
				}
				else
				{
					// [_unit] spawn (TCL_Marker_F select 2);
					
					// player sideChat format ["TCL_Marker_F > Changed > %1", _unit];
					
					// _unit = objNull;
				};
			};
			
			_type = "Switchable";
			
			if (_unit in (TCL_Players select 0) ) then
			{
				_type = "Playable";
			};
			
			if (isNull objectParent _unit) then
			{
				_displayName = "";
			}
			else
			{
				_vehicle = (vehicle _unit);
				
				_displayName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
			};
			
			_marker setMarkerText format ["%1 ( %2 ) %3 ( %4 ) %5", _unit, _side, _type, (behaviour _unit), _displayName];
			
			_marker setMarkerDir (getDir _unit);
			
			_marker setMarkerPos (getPos _unit);
		};
		
		sleep 1;
	};
	
	deleteMarker _marker;
	
	}
];