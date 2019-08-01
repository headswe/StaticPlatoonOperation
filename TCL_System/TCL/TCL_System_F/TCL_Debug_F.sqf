TCL_Debug_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Debug Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Debug
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_array"];
	
	_array = _this;
	
	private _header = _array call (TCL_Header_F select 1);
	
	private ["_text","_string"];
	
	while { (TCL_Preprocess) } do
	{
		_text = "<t size='1.3' color='#bebebe'>Working</t>";
		
		_string = parseText (_header + _text);
		
		hint _string;
		
		sleep 0.01;
	};
	
	if (TCL_Path isEqualTo "\TCL_System\") then
	{
		_text = "<t size='1.3'> <t color='#0000ff'>AddOn Based</t> <t color='#bebebe'>( Done )</t></t>";
	}
	else
	{
		_text = "<t size='1.3'> <t color='#0000ff'>Sctipt Based</t> <t color='#bebebe'>( Done )</t></t>";
	};
	
	_string = parseText (_header + _text);
	
	hint _string;
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Debug Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Debug
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_array"];
	
	_array = _this;
	
	private _header = _array call (TCL_Header_F select 1);
	
	private _text = format ["<t color='#bebebe'>Server:</t> %1<br/><t color='#bebebe'>Multiplayer:</t> %2<br/><t color='#bebebe'>Dedicated:</t> %3", (TCL_Server), (TCL_Multiplayer), (TCL_Dedicated) ];
	
	private ["_object","_group","_string","_enemy","_knowledge"];
	
	while { (True) } do
	{
		_object = cursorTarget;
		
		if (alive _object) then
		{
			_group = (group _object);
			
			if (isNull _group) then
			{
				_string = format ["%1<t align='center'><t color='#bebebe'>Object:</t> %2<br/><t color='#bebebe'>Type:</t> %3<br/><t color='#bebebe'>Distance:</t> %4<br/>%5", _header, _object, (typeOf _object), (player distance _object), _text];
			}
			else
			{
				// _string = format ["%1<t align='center'><t color='#bebebe'>Group:</t> %2<br/><t color='#bebebe'>Unit:</t> %3<br/><t color='#bebebe'>Knowledge:</t> %4<br/><t color='#bebebe'>Behaviour:</t> %5<br/><t color='#bebebe'>Combat Mode:</t> %6<br/><t color='#bebebe'>Type:</t> %7<br/><t color='#bebebe'>Distance:</t> %8<br/></t>%9", _header, _group, _object, (_object knowsAbout vehicle player), (behaviour _object), (combatMode _object), (typeOf _object), (player distance _object), _text];
				
				_knowledge = 0;
				
				_enemy = objNull;
				
				if (_group in (TCL_Groups select 0) ) then
				{
				
				_enemy = (_group getVariable "TCL_Enemy");
				
				if (alive _enemy) then
				{
					if (_object targetKnowledge _enemy select 0) then
					{
						_knowledge = (_object knowsAbout vehicle _enemy);
					};
				}
				else
				{
					_enemy = "Unknown";
				};
				
				};
				
				_string = format ["%1<t align='center'><t color='#bebebe'>Group:</t> %2<br/><t color='#bebebe'>Unit:</t> %3<br/><t color='#bebebe'>Skill:</t> %4<br/><t color='#bebebe'>Enemy:</t> %5<br/><t color='#bebebe'>Knowledge:</t> %6<br/><t color='#bebebe'>Behaviour:</t> %7<br/><t color='#bebebe'>Combat Mode:</t> %8<br/><t color='#bebebe'>Speed Mode:</t> %9<br/><t color='#bebebe'>Type:</t> %10<br/><t color='#bebebe'>Distance:</t> %11<br/></t>%12", _header, _group, _object, (skill _object), _enemy, _knowledge, (behaviour _object), (combatMode _object), (speedMode _object), (typeOf _object), (player distance _object), _text];
			};
			
			hint parseText _string;
		};
		
		sleep 1;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Debug Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Debug
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_array","_groups","_array","_count","_logic","_group","_units","_textUnit","_textGroup","_string"];
	
	_array = _this;
	
	private _header = _array call (TCL_Header_F select 1);
	
	while { (True) } do
	{
		_array = (TCL_Logic select 0);
		
		if (count _array > 0) then
		{
			_groups = [];
			
			_count = 0;
			
			for "_count" from _count to (count _array - 1) do
			{
				_logic = (_array select _count);
				
				_group = (_logic getVariable "TCL_Group");
				
				if (_group == group player) exitWith
				{
					_groups = (_logic getVariable "TCL_Reinforcement");
				};
			};
			
			if (count _groups > 0) then
			{
				_units = [];
				
				{_units append units _x} forEach _groups;
				
				_textUnit = "Unit";
				
				if (count _units > 1) then
				{
					_textUnit = "Units";
				};
				
				_textGroup = "Group";
				
				if (count _groups > 1) then
				{
					_textGroup = "Groups";
				};
				
				_string = format ["%1<t align='center'>Currently there are <br/><t size='1.3' color='#ff0000'>%2</t> <t size='1.3' color='#bebebe'>A.I. %3</t><br/>which holds<br/><t size='1.3' color='#ff0000'>%4</t> <t size='1.3' color='#bebebe'>A.I. %5</t><br/>trying to kill you!", _header, count _groups, _textGroup, count _units, _textUnit];
				
				hint parseText _string;
				
				sleep 10;
				
				hint "";
			};
		};
		
		sleep 5;
	};
	
	},
	
	// ////////////////////////////////////////////////////////////////////////////
	// Debug Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Debug
	// By =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{params ["_unit","_enemy","_array"];
	
	private _rgba = [1,1,1,1];
	
	private _marker = format ["%1", _unit];
	
	private _color = "colorWhite";
	
	if (_unit in _array) then
	{
		_rgba = [1,0,0,1];
		
		_color = (markerColor _marker);
	};
	
	private _count = 100;
	
	while { (_count > 0) } do
	{
		if (alive _unit) then
		{
			drawLine3D [getPos _unit, getPos _enemy, _rgba];
			
			_marker setMarkerColor _color;
			
			sleep 0.01;
		}
		else
		{
			_count = 0;
			
			_marker setMarkerColor "ColorGrey";
		};
		
		_count = _count - 1;
	};
	
	}
];