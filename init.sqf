dsm_opforFaction = "OPF_F";
dsm_bluFaction = "BLU_F";
dsm_vehicleFaction = "";
spo_seed = random [1000, 5000, 10000];
spo_allowedRoles = ['r','ftl','g','aar','ar','rat','m','mmgg', 'dm' , 'sn', 'matg'];
private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if (!isMultiplayer) then { _playerCount = 10;};
dsm_aiRatio = 6;
spo_ai_initialManpower =  round ((5 + (_playerCount * dsm_aiRatio) ) min 120);
dsm_objective_radius = 200;
dsm_perimeter_radius = 800;
if(serverCommandAvailable "#kick") then {
	dsm_click_action = addMissionEventHandler ["MapSingleClick", {
		params ["_units", "_pos", "_alt", "_shift"];
		[[_pos#0, _pos#1, 0]] remoteExecCall ['dsm_fnc_setObjective',2]; 
	}];
};
if (!isServer) exitWith {};
// Number of players

