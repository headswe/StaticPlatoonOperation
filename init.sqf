dsm_opforFaction = "OPF_F";
dsm_bluFaction = "BLU_F";
dsm_aiRatio = 4;
if (!isServer) exitWith {}; // only run on server.
	// AI Spawner... (Assault Objective)

KK_fnc_arrayShuffle = {
	private _cnt = count _this;
	for "_i" from 1 to _cnt do {
		_this pushBack (_this deleteAt floor random _cnt);
	};
	_this
};
fn_trans_pos = {
	params["_pos","_length","_angle"];
    
    _pos2 = +_pos;
	_pos2 set [1,(_pos select 1) + (cos(_angle)*_length)];
	_pos2 set [0,(_pos select 0) + (sin(_angle)*_length)];
	_pos2
};

	
private _locationMarkers = [];
for "_i" from 1 to 200 do {
	private _location = getMarkerPos format ["assault_%1",_i];
	if (_location isEqualTo [0,0,0]) exitWith {};
	_locationMarkers pushBack _location;
};
[_locationMarkers,true] call CBA_fnc_shuffle; 


private _centerPos = selectRandom _locationMarkers;
dsm_centerPos = _centerPos;
publicVariable "dsm_centerPos";
dsm_objective_radius = 150;
publicVariable "dsm_objective_radius";
dsm_perimeter_radius = 850;
publicVariable "dsm_perimeter_radius";
dsm_specobjective_module setPos [_centerPos#0, _centerPos#1,15];

////// Setup markers...

// Assault Marker
_mkr = createMarker ["assaultObjective",_centerPos];
_mkr setMarkerSize [0.5,0.5];
_mkr setMarkerType "mil_dot";
_mkr setMarkerColor "ColorRed";
//_mkr setMarkerText "Assault";

// Perimeter.
_mkr = createMarker ["assaultObjectivePerimeter",_centerPos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerBrush "Border";
_mkr setMarkerSize [dsm_objective_radius,dsm_objective_radius];
_mkr setMarkerColor "ColorRed";

// Teleport permiter
_mkr = createMarker ["assaultObjectiveTP",_centerPos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerBrush "Border";
_mkr setMarkerSize [dsm_perimeter_radius,dsm_perimeter_radius];
_mkr setMarkerColor "ColorBlue";


/////// AI SPAWN

// Number of players
private _playerCount = (count (playableUnits + switchableUnits)) max 1;
if (!isMultiplayer) then { _playerCount = 10;};
dsm_opforFaction = "OPF_F";
dsm_bluFaction = "BLU_F";
dsm_aiRatio = 6;
dsm_aiRatioCount =  round ((5 + (_playerCount * dsm_aiRatio) ) min 120);


