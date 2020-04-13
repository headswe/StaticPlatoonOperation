private _loadouts = ("true" configClasses (configFile >> "CfgLoadouts")) apply {
	[getText (_x >> "category"), getText (_x >> "displayName")]
};
_loadouts sort true;

private _text = "Loadouts available for players and enemies:";
private _header = "";

{
	_x params ["_category", "_name"];
	
	if !(_category isEqualTo _header) then {
		_header = _category;
		_text = format ["%1<br/><br/><font size='18'>%2</font>", _text, toUpper _category];
	};

	_text = format ["%1<br/>%2", _text, _name];
} forEach _loadouts;

player createDiaryRecord ["diary", ["Available Loadouts", _text]];