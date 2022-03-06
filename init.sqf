spo_opforFaction = "OPF_F";
spo_bluFaction = "BLU_F";
spo_vehicleFaction = "";
spo_centerPos = [0,0,0];
spo_reinforcement_locations = [];
spo_seed = random [1000, 5000, 10000];
spo_allowedRoles = ['r','ftl','g','aar','ar','rat','m','mmgg', 'dm' , 'sn', 'matg'];
private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if (!isMultiplayer) then { _playerCount = 10;};
spo_aiRatio = 6;
spo_ai_initialManpower =  round ((5 + (_playerCount * spo_aiRatio) ) min 120);
spo_objective_radius = 200;
spo_perimeter_radius = 400;
spo_patrol_groups = [];
if(serverCommandAvailable "#kick") then {
	spo_click_action = addMissionEventHandler ["MapSingleClick", {
		params ["_units", "_pos", "_alt", "_shift"];
		[[_pos#0, _pos#1, 0]] remoteExecCall ['spo_fnc_setObjective',2]; 
	}];
};
if (!isServer) exitWith {};


spo_speakers = ["Male01ENG","Male02ENG","Male03ENG","Male04ENG","Male05ENG","Male06ENG","Male07ENG","Male08ENG","Male09ENG","Male10ENG","Male11ENG","Male12ENG"];