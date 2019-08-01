params ["_type", "_args"];
disableSerialization;
switch (_type) do {
	case "onLoad": {
		_args params ['_dialog'];
		uiNamespace setVariable ["dsm_dialog_setup", _dialog];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;
		private _map = _dialog displayCtrl 1801;
		_map ctrlMapAnimAdd [0, 0.2, dsm_centerPos];
		ctrlMapAnimCommit _map;
		{
			_loadout = _x;
			{
				_index = _x lbAdd (getText (_loadout >> "displayName"));
				_x lbSetData [_index, configName _loadout];
			} foreach [_pFactionControl, _eFactionControl];
		} forEach ("true" configClasses (configFile >> "CfgLoadouts"));
		lbSort [_pFactionControl, "ASC"];
		lbSort [_eFactionControl, "ASC"];
	 };
	 case "done": {
		_dialog = uiNamespace getVariable ["dsm_dialog_setup", displayNull];
		private _pFactionControl = _dialog displayCtrl 2100;
		private _eFactionControl = _dialog displayCtrl 2101;

		dsm_bluFaction = _pFactionControl lbData (lbCurSel _pFactionControl);
		publicVariable 'dsm_bluFaction';
		dsm_opforFaction = _eFactionControl lbData (lbCurSel _eFactionControl);
		publicVariable 'dsm_opforFaction';
		remoteExecCall ['dsm_fnc_setup', 2, false];
		closeDialog 1;
	 };
	default { };
};