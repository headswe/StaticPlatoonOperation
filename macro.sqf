params ["_input"];

private _values = [];
private _texts = [];

{
	_values pushBack (configName _x);
	_texts pushBack (getText (_x >> "displayName"));
	
} forEach ("true" configClasses (configFile >> "CfgLoadouts"));

private _output = "";
private _var = _values;
if (_input == "texts") then { _var = _texts;};
/*{
	if (_forEachIndex == ((count _var) -1)) then { _output = _output + """"; };
	if (_forEachIndex != 0) then { _output = _output + ", "; };
	_output = _output + """" + _x + """";
	if (_forEachIndex == 0) then { _output = _output + """"; };
} forEach _var;
_output = _output + "";
_output;*/

_var resize 100;
{if (isNil "_x") then { _var set [_forEachIndex,0]};} forEach _var;
_var;
/*

values[] = { __EVAL( private _config = configFile >> "CfgLoadouts"; private _configs = "true" configClasses _config; private _values = []; private _texts = []; private _output = ""; { private _cond = _forEachIndex != 0; if _cond then { _output = _output + ", "; }; _output = _output + "'" + configName _x + "'"; } forEach _configs; _output;) };
		texts[] = { __EVAL( private _config = configFile >> "CfgLoadouts"; private _configs = "true" configClasses _config; private _values = []; private _texts = []; private _output = ""; { private _cond = _forEachIndex != 0; if _cond then { _output = _output + ", "; }; private _displaynamecfg = _x >> "displayName"; _output = _output + "'" + getText _displaynamecfg + "'"; } forEach _configs; _output;) };
		*/
		
		/*		values[] = { __EVAL(['values'] call compile preProcessFile 'macro.sqf') };
		texts[] = { __EVAL(['texts'] call compile preProcessFile 'macro.sqf') };*/