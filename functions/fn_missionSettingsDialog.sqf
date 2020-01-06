params ["_type", "_args"];
disableSerialization;
switch (_type) do {
	case "onLoad": {
		_args params ['_dialog'];
		uiNamespace setVariable ["dsm_dialog_setup", _dialog];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _enemyFactionVehiclesControl = _dialog displayCtrl 2003;
		private _aiRatioControl = _dialog displayCtrl 1900;
		private _map = _dialog displayCtrl 1801;
		_map ctrlMapAnimAdd [0, 0.2, dsm_centerPos];
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
			(dsm_factions getVariable _x) params ['_faction', '_displayName'];
			_index = _enemyFactionVehiclesControl lbAdd _displayName;
			_enemyFactionVehiclesControl lbSetData [_index, _x];
		} forEach (allVariables dsm_factions);

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
		} forEach [1,2,3,4,5,6,7,9,10];
		_aiRatioControl lbSetCurSel 0;
	 };
	 case "done": {
		removeMissionEventHandler ["MapSingleClick", dsm_click_action];
		_dialog = uiNamespace getVariable ["dsm_dialog_setup", displayNull];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _aiRatioControl = _dialog displayCtrl 1900;
		private _enemyFactionVehiclesControl = _dialog displayCtrl 2003;
		dsm_bluFaction = _pFactionControl lbData (lbCurSel _pFactionControl);
		publicVariable 'dsm_bluFaction';
		dsm_opforFaction = _eFactionControl lbData (lbCurSel _eFactionControl);
		publicVariable 'dsm_opforFaction';
		dsm_aiRatio = parseNumber(_aiRatioControl lbData (lbCurSel _aiRatioControl));
		dsm_vehicleFaction = _enemyFactionVehiclesControl lbData (lbCurSel _enemyFactionVehiclesControl);
		publicVariable 'dsm_vehicleFaction';
		remoteExecCall ['dsm_fnc_setup', 2, false];
		closeDialog 1;
	 };
	default { };
};