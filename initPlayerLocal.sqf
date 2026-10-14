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

// Admin rights can be gained (#login) or lost at any time, so poll instead of checking once at init.
spo_isAdmin = false;
[{
	private _isAdmin = serverCommandAvailable "#kick";
	if (_isAdmin isEqualTo spo_isAdmin) exitWith {};
	spo_isAdmin = _isAdmin;
	[_isAdmin] call spo_fnc_onAdminChanged;
}, 2] call CBA_fnc_addPerFrameHandler;
