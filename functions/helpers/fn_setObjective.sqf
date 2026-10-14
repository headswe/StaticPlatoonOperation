params ['_centerPos'];
// only admins may move the objective, and only before the AI has been spawned
if (!(call spo_fnc_isAdminCaller) || {spo_aiSpawned}) exitWith {};
_centerPos set [2,0];
// Assault Marker. Local setters, then one global setMarkerColor syncs each marker.
deleteMarker "assaultObjective";
private _mkr = createMarker ["assaultObjective",_centerPos];
_mkr setMarkerSizeLocal [0.5,0.5];
_mkr setMarkerTypeLocal "mil_dot";
_mkr setMarkerColor "ColorRed";

// Perimeter.
spo_perimeter_mkrName = "assaultObjectivePerimeter";
deleteMarker spo_perimeter_mkrName;
_mkr = createMarker [spo_perimeter_mkrName,_centerPos];
_mkr setMarkerShapeLocal "ELLIPSE";
_mkr setMarkerBrushLocal "Border";
_mkr setMarkerSizeLocal [spo_objective_radius, spo_objective_radius];
_mkr setMarkerColor "ColorRed";

// Teleport permiter
spo_ao_mkrName = "assaultObjectiveTP";
deleteMarker spo_ao_mkrName;
_mkr = createMarker [spo_ao_mkrName, _centerPos];
_mkr setMarkerShapeLocal "ELLIPSE";
_mkr setMarkerBrushLocal "Border";
_mkr setMarkerSizeLocal [spo_perimeter_radius,spo_perimeter_radius];
_mkr setMarkerColor "ColorBlue";

// do it
spo_centerPos = _centerPos;
publicVariable "spo_centerPos";
spo_specobjective_module setPos [_centerPos#0, _centerPos#1,15];
spo_reinforcement_locations = [];
[spo_centerPos, 1000, [0,90,180,270]] spawn spo_fnc_getReinforcementLocations;

spo_objective_area = [spo_objective_radius, spo_objective_radius, 0, false];
spo_perimeter_area = [spo_perimeter_radius * 0.8, spo_perimeter_radius * 0.8, 0, false];
