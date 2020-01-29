dsm_opforFaction = "OPF_F";
dsm_bluFaction = "BLU_F";
dsm_vehicleFaction = "";

private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if (!isMultiplayer) then { _playerCount = 10;};
dsm_aiRatio = 6;
dsm_aiRatioCount =  round ((5 + (_playerCount * dsm_aiRatio) ) min 120);
dsm_objective_radius = 150;
dsm_perimeter_radius = 850;
if(serverCommandAvailable "#kick") then {
	dsm_click_action = addMissionEventHandler ["MapSingleClick", {
		params ["_units", "_pos", "_alt", "_shift"];
		[[_pos#0, _pos#1, 0]] remoteExecCall ['dsm_fnc_setObjective',2]; 
	}];
};
if (!isServer) exitWith {};
// Number of players

