params ["_type", "_args"];
disableSerialization;
switch (_type) do {
	case "onLoad": {
		_args params ['_dialog'];
		uiNamespace setVariable ["spo_dialog_setup", _dialog];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _enemyFactionVehiclesControl = _dialog displayCtrl 2003;
		private _aiRatioControl = _dialog displayCtrl 1900;
		private _missionControl = _dialog displayCtrl 2004;
		private _map = _dialog displayCtrl 1801;
		_map ctrlMapAnimAdd [0, 0.2, spo_centerPos];
		private _loadouts = ("true" configClasses (configFile >> "CfgLoadouts"));
		ctrlMapAnimCommit _map;
		{
			private _loadout = _x;
			{
				private _index = _x lbAdd (getText (_loadout >> "displayName"));
				_x lbSetData [_index, configName _loadout];
			} forEach [_pFactionControl, _eFactionControl];
		} forEach _loadouts;

		private _index = _enemyFactionVehiclesControl lbAdd '';
		_enemyFactionVehiclesControl lbSetData [_index, ''];
		_enemyFactionVehiclesControl lbSetCurSel _index;
		// add factions
		{
			_x params ['_faction', '_displayName'];
			_index = _enemyFactionVehiclesControl lbAdd _displayName;
			_enemyFactionVehiclesControl lbSetData [_index, _faction];
		} forEach (missionNamespace getVariable ["spo_factions", []]); // filled by the server shortly after start

		{
			_index = _missionControl lbAdd (getText (_x >> "displayName"));
			_missionControl lbSetData [_index, configName _x];
		} forEach ("true" configClasses (missionConfigFile >> "SPO_Missions"));

		// sort
		lbSort [_pFactionControl, "ASC"];
		lbSort [_eFactionControl, "ASC"];
		lbSort [_enemyFactionVehiclesControl, "ASC"];
		_pFactionControl lbSetCurSel (floor random lbSize _pFactionControl);
		_eFactionControl lbSetCurSel (floor random lbSize _eFactionControl);
        _enemyFactionVehiclesControl lbSetCurSel (floor random lbSize _enemyFactionVehiclesControl);
        _missionControl lbSetCurSel 0;
		for "_i" from 2 to 58 step 2 do {
			_index = _aiRatioControl lbAdd (str _i);
			_aiRatioControl lbSetData [_index, str _i];
		};
		_aiRatioControl lbSetCurSel 0;
	 };
	 case "done": {
		if (!isNil "spo_click_action") then {
			removeMissionEventHandler ["MapSingleClick", spo_click_action];
			spo_click_action = nil;
		};
		private _dialog = uiNamespace getVariable ["spo_dialog_setup", displayNull];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _aiRatioControl = _dialog displayCtrl 1900;
		private _enemyFactionVehiclesControl = _dialog displayCtrl 2003;
		private _missionControl = _dialog displayCtrl 2004;
		spo_bluFaction = _pFactionControl lbData (lbCurSel _pFactionControl);
		publicVariable 'spo_bluFaction';
		spo_opforFaction = _eFactionControl lbData (lbCurSel _eFactionControl);
		publicVariable 'spo_opforFaction';
		spo_aiRatio = parseNumber(_aiRatioControl lbData (lbCurSel _aiRatioControl));
		publicVariable 'spo_aiRatio';
		spo_vehicleFaction = _enemyFactionVehiclesControl lbData (lbCurSel _enemyFactionVehiclesControl);
		publicVariable 'spo_vehicleFaction';
		spo_missionClassName = _missionControl lbData (lbCurSel _missionControl);
		publicVariable 'spo_missionClassName';
		remoteExecCall ['spo_fnc_setup', 2, false];
		closeDialog 1;
	 };
	default { };
};
