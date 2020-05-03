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
		private _map = _dialog displayCtrl 1801;
		_map ctrlMapAnimAdd [0, 0.2, spo_centerPos];
		_loadouts = ("true" configClasses (configFile >> "CfgLoadouts"));
		ctrlMapAnimCommit _map;
		{
			_loadout = _x;
			{
				_index = _x lbAdd (getText (_loadout >> "displayName"));
				_x lbSetData [_index, configName _loadout];
			} foreach [_pFactionControl, _eFactionControl];
		} forEach _loadouts;

		_index = _enemyFactionVehiclesControl lbAdd '';
		_enemyFactionVehiclesControl lbSetData [_index, ''];
		_enemyFactionVehiclesControl lbSetCurSel _index;
		// add factions
		{
			_x params ['_faction', '_displayName'];
			_index = _enemyFactionVehiclesControl lbAdd _displayName;
			_enemyFactionVehiclesControl lbSetData [_index, _faction];
		} forEach spo_factions;

		// sort
		lbSort [_pFactionControl, "ASC"];
		lbSort [_eFactionControl, "ASC"];
		lbSort [_enemyFactionVehiclesControl, "ASC"];
		_pFactionControl lbSetCurSel (random floor count _loadouts);
		_eFactionControl lbSetCurSel (random floor count _loadouts);

		_i = 2;
		{
			_i = _i + 2; 
			_index = _aiRatioControl lbAdd (str _i);
			_aiRatioControl lbSetData [_index,str _i];
		} forEach [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30];
		_aiRatioControl lbSetCurSel 0;
	 };
	 case "done": {
		removeMissionEventHandler ["MapSingleClick", spo_click_action];
		_dialog = uiNamespace getVariable ["spo_dialog_setup", displayNull];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _aiRatioControl = _dialog displayCtrl 1900;
		private _enemyFactionVehiclesControl = _dialog displayCtrl 2003;
		spo_bluFaction = _pFactionControl lbData (lbCurSel _pFactionControl);
		publicVariable 'spo_bluFaction';
		spo_opforFaction = _eFactionControl lbData (lbCurSel _eFactionControl);
		publicVariable 'spo_opforFaction';
		spo_aiRatio = parseNumber(_aiRatioControl lbData (lbCurSel _aiRatioControl));
		publicVariable 'spo_aiRatio';
		spo_vehicleFaction = _enemyFactionVehiclesControl lbData (lbCurSel _enemyFactionVehiclesControl);
		publicVariable 'spo_vehicleFaction';
		remoteExecCall ['spo_fnc_setup', 2, false];
		closeDialog 1;
	 };
	default { };
};