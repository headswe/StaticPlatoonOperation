// The convoy knows it is under attack: a vehicle took damage, someone in it died, or it spotted players.
private _grp = _this getVariable ["spo_convoy_group", grpNull];
private _vehicles = _this getVariable ["spo_convoy_vehicles", []];
(_vehicles findIf {!alive _x || {damage _x > 0.05}} != -1) ||
{(_vehicles findIf {(crew _x) findIf {!alive _x} != -1} != -1)} ||
{!isNull _grp && {_grp call spo_fnc_inContact}}
