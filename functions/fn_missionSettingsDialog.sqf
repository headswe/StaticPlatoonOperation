// Mission setup dialog (ui\missionDialog.hpp). Runs on the admin's machine only.
// Cases: onLoad, onUnload, filter, select, role, ratio, mapClick, refresh, done.
params ["_type", "_args"];
disableSerialization;

#define IDC_STATUS 1002
#define IDC_SCAN_TEXT 1003
#define IDC_SCAN_BAR 1004
#define IDC_PREVIEW_BLU_NAME 1210
#define IDC_PREVIEW_OP_NAME 1211
#define IDC_MAP 1801
#define IDC_RATIO 1900
#define IDC_RATIO_VALUE 1901
#define IDC_MISSION 2004
#define IDC_TIME 2005
#define IDC_WEATHER 2006
#define IDC_ROLE 2007
#define IDC_LIST_BLU 2100
#define IDC_LIST_OP 2101
#define IDC_LIST_VEH 2102
#define IDC_GO 1600

// [idc of checkbox, vehicle category used by spo_fnc_vehicleCategory]
#define VEHICLE_BOXES [[2201, "car"], [2202, "apc"], [2203, "tank"], [2204, "heli"]]

private _display = uiNamespace getVariable ["spo_dialog_setup", displayNull];

// Fills a list with the entries matching the filter text and reselects the remembered entry.
// Entries are [text, data, textRight]; an entry with empty data (e.g. "None") always shows.
private _fillList = {
	params ["_list"];
	private _entries = _list getVariable ["spo_entries", []];
	private _filter = toLower (_list getVariable ["spo_filter", ""]);
	private _selected = _list getVariable ["spo_selected", ""];
	uiNamespace setVariable ["spo_setup_filling", true];
	lbClear _list;
	{
		_x params ["_text", "_data", "_right"];
		if (_filter isEqualTo "" || {_data isEqualTo ""} || {(toLower _text) find _filter >= 0} || {(toLower _right) find _filter >= 0}) then {
			private _index = _list lbAdd _text;
			_list lbSetData [_index, _data];
			_list lbSetTextRight [_index, _right];
		};
	} forEach _entries;
	_list lbSetCurSel -1;
	for "_i" from 0 to (lbSize _list) - 1 do {
		if ((_list lbData _i) isEqualTo _selected) exitWith { _list lbSetCurSel _i; };
	};
	uiNamespace setVariable ["spo_setup_filling", false];
};

// Re-gears a preview doll for the given faction with the role picked in the role combo.
private _updatePreview = {
	params ["_side"];
	private _previews = uiNamespace getVariable ["spo_setup_previews", []];
	private _preview = _previews select {(_x # 0) isEqualTo _side};
	if (_preview isEqualTo []) exitWith {};
	(_preview # 0) params ["", "", "_doll"];
	private _list = _display displayCtrl ([IDC_LIST_OP, IDC_LIST_BLU] select (_side isEqualTo "blu"));
	private _nameCtrl = _display displayCtrl ([IDC_PREVIEW_OP_NAME, IDC_PREVIEW_BLU_NAME] select (_side isEqualTo "blu"));
	private _faction = _list getVariable ["spo_selected", ""];
	_nameCtrl ctrlSetText getText (configFile >> "CfgLoadouts" >> _faction >> "displayName");
	if (_faction isEqualTo "" || {isNull _doll}) exitWith {};

	private _roleCtrl = _display displayCtrl IDC_ROLE;
	private _role = _roleCtrl lbData (lbCurSel _roleCtrl);
	if (!isClass (configFile >> "CfgLoadouts" >> _faction >> _role)) then { _role = "r"; };
	_doll setVariable ["tmf_assignGear_faction", _faction];
	_doll setVariable ["tmf_assignGear_role", _role];
	_doll call tmf_assignGear_fnc_assignGear;
	_doll switchMove (["AmovPercMstpSnonWnonDnon", "AmovPercMstpSlowWrflDnon"] select (primaryWeapon _doll isNotEqualTo ""));
};

private _objectiveSet = { getMarkerColor "assaultObjective" isNotEqualTo "" };

switch (_type) do {
	case "onLoad": {
		_args params ["_dialog"];
		_display = _dialog;
		uiNamespace setVariable ["spo_dialog_setup", _dialog];

		// Faction lists: player and enemy factions come from TMF loadouts
		private _loadouts = ("true" configClasses (configFile >> "CfgLoadouts")) apply {
			[getText (_x >> "displayName"), configName _x, getText (_x >> "category")]
		};
		_loadouts sort true;
		{
			_x params ["_idc", "_current"];
			private _list = _dialog displayCtrl _idc;
			_list setVariable ["spo_entries", _loadouts];
			// keep the last used faction, otherwise pick one at random
			if ((_loadouts findIf {(_x # 1) isEqualTo _current}) == -1 && {_loadouts isNotEqualTo []}) then {
				_current = (selectRandom _loadouts) # 1;
			};
			_list setVariable ["spo_selected", _current];
			[_list] call _fillList;
		} forEach [[IDC_LIST_BLU, spo_bluFaction], [IDC_LIST_OP, spo_opforFaction]];
		(_dialog displayCtrl IDC_LIST_VEH) setVariable ["spo_selected", spo_vehicleFaction];

		// Mission types
		private _missionCtrl = _dialog displayCtrl IDC_MISSION;
		{
			private _index = _missionCtrl lbAdd (getText (_x >> "displayName"));
			_missionCtrl lbSetData [_index, configName _x];
			if (configName _x == spo_missionClassName) then { _missionCtrl lbSetCurSel _index; };
		} forEach ("true" configClasses (missionConfigFile >> "SPO_Missions"));
		if (lbCurSel _missionCtrl < 0) then { _missionCtrl lbSetCurSel 0; };

		// Enemy strength
		private _ratioCtrl = _dialog displayCtrl IDC_RATIO;
		_ratioCtrl sliderSetRange [2, 58];
		_ratioCtrl sliderSetSpeed [2, 2];
		_ratioCtrl sliderSetPosition spo_aiRatio;
		["ratio", [_ratioCtrl, spo_aiRatio]] call spo_fnc_missionSettingsDialog;

		// Time of day and weather; index 0 keeps what XEH_preInit rolled at mission start
		private _timeCtrl = _dialog displayCtrl IDC_TIME;
		_timeCtrl lbSetValue [_timeCtrl lbAdd format ["Keep current (%1)", [dayTime, "HH:MM"] call BIS_fnc_timeToString], -1];
		for "_hour" from 0 to 23 do {
			_timeCtrl lbSetValue [_timeCtrl lbAdd format ["%1:00", [str _hour, "0" + str _hour] select (_hour < 10)], _hour];
		};
		_timeCtrl lbSetCurSel 0;
		private _weatherCtrl = _dialog displayCtrl IDC_WEATHER;
		_weatherCtrl lbSetValue [_weatherCtrl lbAdd "Keep current", -1];
		{
			_weatherCtrl lbSetValue [_weatherCtrl lbAdd _x, _forEachIndex];
		} forEach ["Clear", "Cloudy", "Mostly cloudy", "Overcast", "Foggy", "Showers", "Light rain", "Heavy rain", "Storm"];
		_weatherCtrl lbSetCurSel 0;

		// Vehicle types
		{
			_x params ["_idc", "_category"];
			(_dialog displayCtrl _idc) cbSetChecked (_category in spo_vehicleTypes);
		} forEach VEHICLE_BOXES;

		// Preview roles
		private _roleCtrl = _dialog displayCtrl IDC_ROLE;
		{
			_x params ["_role", "_name"];
			_roleCtrl lbSetData [_roleCtrl lbAdd _name, _role];
		} forEach [
			["r", "Rifleman"], ["ftl", "Fireteam leader"], ["ar", "Autorifleman"], ["aar", "Asst. autorifleman"],
			["g", "Grenadier"], ["rat", "Rifleman (AT)"], ["m", "Medic"], ["dm", "Marksman"], ["sn", "Sniper"],
			["mmgg", "MMG gunner"], ["matg", "MAT gunner"], ["vc", "Vehicle commander"], ["p", "Pilot"]
		];
		_roleCtrl lbSetCurSel 0;

		// Preview dolls: local units high above the map corner, each filmed by its own render-to-texture camera
		private _previews = [];
		{
			_x params ["_side", "_unitClass", "_pos", "_rtt", "_pictureIdc"];
			// render at the picture's real on-screen aspect ratio, which depends on the player's resolution and UI size
			private _picture = _dialog displayCtrl _pictureIdc;
			(ctrlPosition _picture) params ["", "", "_w", "_h"];
			(getResolution) params ["_resX", "_resY"];
			private _aspect = ((_w / safezoneW) * _resX) / (((_h / safezoneH) * _resY) max 1);
			_picture ctrlSetText format ["#(argb,512,1024,1)r2t(%1,%2)", _rtt, _aspect];
			private _anchor = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
			_anchor setPosASL _pos;
			private _doll = _unitClass createVehicleLocal [0, 0, 0];
			_doll attachTo [_anchor, [0, 0, 0]];
			private _cam = "camera" camCreate [0, 0, 0];
			_cam camSetPos (_anchor modelToWorld [0.15, 3.4, 1.05]);
			_cam camSetTarget (_anchor modelToWorld [0, 0, 0.95]);
			_cam camSetFov 0.42;
			_cam camCommit 0;
			_cam cameraEffect ["Internal", "Back", _rtt];
			_rtt setPiPEffect [0];
			private _light = "#lightpoint" createVehicleLocal [0, 0, 0];
			_light setPosASL (_pos vectorAdd [1, 2.5, 2]);
			_light setLightColor [1, 1, 1];
			_light setLightAmbient [0.6, 0.6, 0.6];
			_light setLightBrightness 0.8;
			_light setLightDayLight true;
			_previews pushBack [_side, _anchor, _doll, _cam, _light, _rtt];
		} forEach [
			["blu", "B_Soldier_F", [60, 60, 1500], "spo_rtt_blu", 1200],
			["op", "O_Soldier_F", [120, 60, 1500], "spo_rtt_op", 1201]
		];
		uiNamespace setVariable ["spo_setup_previews", _previews];
		["blu"] call _updatePreview;
		["op"] call _updatePreview;

		// Keep the objective, map and config scan progress up to date while the dialog is open
		[] spawn {
			disableSerialization;
			private _display = uiNamespace getVariable ["spo_dialog_setup", displayNull];
			while {!isNull _display} do {
				["refresh"] call spo_fnc_missionSettingsDialog;
				uiSleep 0.25;
			};
		};
	};
	case "onUnload": {
		{
			_x params ["", "_anchor", "_doll", "_cam", "_light", "_rtt"];
			_cam cameraEffect ["Terminate", "Back", _rtt];
			camDestroy _cam;
			{ deleteVehicle _x; } forEach [_doll, _anchor, _light];
		} forEach (uiNamespace getVariable ["spo_setup_previews", []]);
		uiNamespace setVariable ["spo_setup_previews", nil];
		uiNamespace setVariable ["spo_dialog_setup", nil];
	};
	case "filter": {
		_args params ["_edit"];
		// each search box sits 10 idcs above its list
		private _list = _display displayCtrl ((ctrlIDC _edit) - 10);
		_list setVariable ["spo_filter", ctrlText _edit];
		[_list] call _fillList;
	};
	case "select": {
		_args params ["_list", "_index"];
		if (uiNamespace getVariable ["spo_setup_filling", false] || {_index < 0}) exitWith {};
		_list setVariable ["spo_selected", _list lbData _index];
		switch (ctrlIDC _list) do {
			case IDC_LIST_BLU: { ["blu"] call _updatePreview; };
			case IDC_LIST_OP: { ["op"] call _updatePreview; };
		};
	};
	case "role": {
		["blu"] call _updatePreview;
		["op"] call _updatePreview;
	};
	case "ratio": {
		_args params ["_slider", "_value"];
		private _ratio = 2 * round (_value / 2);
		_slider sliderSetPosition _ratio;
		// same count as spo_fnc_setup: connected players only, not empty or AI-filled slots
		private _players = (count (allPlayers - entities "HeadlessClient_F")) max 1;
		private _total = round (5 + _players * _ratio);
		private _valueCtrl = _display displayCtrl IDC_RATIO_VALUE;
		_valueCtrl ctrlSetText format ["%1  (~%2 AI)", _ratio, _total];
		_valueCtrl ctrlSetTooltip format ["%1 player%2 x %3 + 5 = %4 enemies in total, at most 180 of them at the start", _players, ["", "s"] select (_players != 1), _ratio, _total];
	};
	case "mapClick": {
		_args params ["_map", "_button", "_mouseX", "_mouseY"];
		if (_button != 0) exitWith {};
		[_map ctrlMapScreenToWorld [_mouseX, _mouseY]] remoteExecCall ["spo_fnc_setObjective", 2];
	};
	case "refresh": {
		if (isNull _display) exitWith {};
		// objective
		private _hasObjective = call _objectiveSet;
		private _status = _display displayCtrl IDC_STATUS;
		if (_hasObjective) then {
			private _pos = getMarkerPos "assaultObjective";
			_status ctrlSetText format ["Objective at grid %1", mapGridPosition _pos];
			_status ctrlSetTextColor [1, 1, 1, 0.8];
			private _map = _display displayCtrl IDC_MAP;
			if ((_map getVariable ["spo_centeredOn", []]) isNotEqualTo _pos) then {
				_map setVariable ["spo_centeredOn", _pos];
				_map ctrlMapAnimAdd [0.3, 0.15, _pos];
				ctrlMapAnimCommit _map;
			};
		} else {
			_status ctrlSetText "Click the map to place the objective";
			_status ctrlSetTextColor [1, 0.75, 0.3, 1];
		};

		// vehicle factions: the server reads CfgVehicles after mission start (spo_fnc_getViableFactions)
		private _vehList = _display displayCtrl IDC_LIST_VEH;
		private _progress = missionNamespace getVariable ["spo_factionScanProgress", 0];
		private _scanned = _progress >= 1 && {!isNil "spo_factions"};
		if (_scanned && {!(_vehList getVariable ["spo_filled", false])}) then {
			_vehList setVariable ["spo_filled", true];
			private _entries = (spo_factions apply { [_x # 1, _x # 0, ""] });
			_entries sort true;
			_vehList setVariable ["spo_entries", [["None (no enemy vehicles)", "", ""]] + _entries];
			[_vehList] call _fillList;
			if (lbCurSel _vehList < 0) then { _vehList lbSetCurSel 0; };
		};
		_vehList ctrlShow _scanned;
		(_display displayCtrl IDC_SCAN_TEXT) ctrlShow !_scanned;
		(_display displayCtrl IDC_SCAN_BAR) ctrlShow !_scanned;
		(_display displayCtrl IDC_SCAN_TEXT) ctrlSetText format ["Reading vehicle configs... %1%2", round (_progress * 100), "%"];
		(_display displayCtrl IDC_SCAN_BAR) progressSetPosition _progress;

		private _go = _display displayCtrl IDC_GO;
		_go ctrlEnable (_hasObjective && _scanned);
		_go ctrlSetTooltip (["Place the objective and wait for the vehicle configs to load first", ""] select (_hasObjective && _scanned));
	};
	case "done": {
		if (!(call _objectiveSet)) exitWith { hint "Click the map to place the objective first."; };
		if (!isNil "spo_click_action") then {
			removeMissionEventHandler ["MapSingleClick", spo_click_action];
			spo_click_action = nil;
		};
		private _missionCtrl = _display displayCtrl IDC_MISSION;
		private _timeCtrl = _display displayCtrl IDC_TIME;
		private _weatherCtrl = _display displayCtrl IDC_WEATHER;
		private _vehicleTypes = (VEHICLE_BOXES select { cbChecked (_display displayCtrl (_x # 0)) }) apply { _x # 1 };
		private _settings = [
			(_display displayCtrl IDC_LIST_BLU) getVariable ["spo_selected", spo_bluFaction],
			(_display displayCtrl IDC_LIST_OP) getVariable ["spo_selected", spo_opforFaction],
			2 * round ((sliderPosition (_display displayCtrl IDC_RATIO)) / 2),
			(_display displayCtrl IDC_LIST_VEH) getVariable ["spo_selected", ""],
			_missionCtrl lbData (lbCurSel _missionCtrl),
			_timeCtrl lbValue (lbCurSel _timeCtrl),
			_weatherCtrl lbValue (lbCurSel _weatherCtrl),
			_vehicleTypes
		];
		[_settings] remoteExecCall ["spo_fnc_setup", 2];
		closeDialog 1;
	};
	default { };
};
