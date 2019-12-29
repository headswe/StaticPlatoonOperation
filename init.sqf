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
	onMapSingleClick {
		params ['_pos'];
		[[_pos#0, _pos#1, 0]] remoteExecCall ['dsm_fnc_setObjective',2]; 
		onMapSingleClick ''
	}
};
if (!isServer) exitWith {}; // only run on server.
	// AI Spawner... (Assault Objective)

	
private _locationMarkers = [];
for "_i" from 1 to 200 do {
	private _location = getMarkerPos format ["assault_%1",_i];
	if (_location isEqualTo [0,0,0]) exitWith {};
	_locationMarkers pushBack _location;
};
[_locationMarkers,true] call CBA_fnc_shuffle; 






/////// AI SPAWN

// Number of players
[] call dsm_fnc_getViableFactions;


