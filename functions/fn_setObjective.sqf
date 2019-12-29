params ['_centerPos'];
// Assault Marker
_mkr = createMarker ["assaultObjective",_centerPos];
_mkr setMarkerSize [0.5,0.5];
_mkr setMarkerType "mil_dot";
_mkr setMarkerColor "ColorRed";

// Perimeter.
dsm_perimeter_mkrName = "assaultObjectivePerimeter";
_mkr = createMarker [dsm_perimeter_mkrName,_centerPos];
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

// do it
dsm_centerPos = _centerPos;
publicVariable "dsm_centerPos";
dsm_specobjective_module setPos [_centerPos#0, _centerPos#1,15];

[dsm_centerPos, 1000, [0,90,180,270]] spawn dsm_fnc_getReinforcementLocations;