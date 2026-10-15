// Convoy mission start (_this = spo_namespace): pick the route, line the convoy up on the road and brief the players.
// Route: between the two road entries farthest apart, through the road nearest the objective centre.
private _entries = spo_reinforcement_locations apply {[_x # 0, _x # 1, 0]};
private _start = [];
private _end = [];
{
	private _a = _x;
	{
		if (_start isEqualTo [] || {(_a distance2D _x) > (_start distance2D _end)}) then { _start = _a; _end = _x; };
	} forEach (_entries - [_a]);
} forEach _entries;
if (_start isEqualTo []) then {
	private _dir = random 360;
	_start = spo_centerPos getPos [spo_perimeter_radius + 400, _dir];
	_end = spo_centerPos getPos [spo_perimeter_radius + 400, _dir + 180];
	{
		private _roads = _x nearRoads 300;
		if (_roads isNotEqualTo []) then { _x set [0, (getPos (_roads # 0)) # 0]; _x set [1, (getPos (_roads # 0)) # 1]; };
	} forEach [_start, _end];
};
private _centerRoads = spo_centerPos nearRoads spo_objective_radius;
private _via = if (_centerRoads isEqualTo []) then { +spo_centerPos } else {
	_centerRoads = _centerRoads apply {[_x distance2D spo_centerPos, _x]};
	_centerRoads sort true;
	getPos ((_centerRoads # 0) # 1)
};

// Staging positions: walk the road away from the route so the column faces its first waypoint.
private _slots = [];
private _road = objNull;
private _startRoads = _start nearRoads 100;
if (_startRoads isNotEqualTo []) then { _road = _startRoads # 0; };
private _visited = [];
private _steps = 0;
while {!isNull _road && {count _slots < 6} && {_steps < 80}} do {
	_steps = _steps + 1;
	_visited pushBack _road;
	if (_slots isEqualTo [] || {(getPos _road) distance2D (_slots # (count _slots - 1)) >= 25}) then { _slots pushBack (getPos _road); };
	private _next = (roadsConnectedTo _road) - _visited;
	_next = _next apply {[_x distance2D _via, _x]};
	_next sort false;  // farthest from the route first, i.e. backwards up the road
	_road = if (_next isEqualTo []) then { objNull } else { (_next # 0) # 1 };
};
while {count _slots < 6} do {
	private _last = if (_slots isEqualTo []) then { _start } else { _slots # (count _slots - 1) };
	_slots pushBack (_last getPos [25, _via getDir _last]);
};

// Composition: escort, one or two supply trucks with troops, escort (plus a second escort sometimes).
private _land = { (_this select {(configName _x) isKindOf "LandVehicle"}) apply {configName _x} };
private _combat = [];
private _transport = [];
if (spo_vehicleFaction != "") then {
	_combat = (call spo_fnc_getCombatVehicle) call _land;
	_transport = (call spo_fnc_getTransportVehicle) call _land;
};
if (_combat isEqualTo []) then { _combat = ["O_MRAP_02_hmg_F"]; };
if (_transport isEqualTo []) then { _transport = ["O_Truck_03_covered_F"]; };
private _plan = ["escort", "supply"];
if (random 1 < 0.6) then { _plan pushBack "supply"; };
_plan pushBack "escort";
if (random 1 < 0.35) then { _plan pushBack "escort"; };

private _grp = createGroup [east, true];
private _vehicles = [];
private _supply = [];
{
	private _role = _x;
	private _pos = _slots # _forEachIndex;
	private _class = selectRandom ([_combat, _transport] select (_role == "supply"));
	private _veh = createVehicle [_class, _pos, [], 0, "NONE"];
	// face the vehicle ahead (the lead faces the route)
	private _ahead = if (_forEachIndex == 0) then { _via } else { _slots # (_forEachIndex - 1) };
	_veh setDir (_pos getDir _ahead);
	_veh setPos _pos;
	// crew every driver, gunner, commander and real turret seat; passenger (FFV) seats stay empty
	private _crewSeats = {(_x # 1) in ["driver", "gunner", "commander"] || {(_x # 1) == "turret" && {!(_x # 4)}}} count (fullCrew [_veh, "", true]);
	private _crew = [_pos, _crewSeats max 1, ["vd", "vg", "vc"], false] call spo_fnc_createSquad;
	{ _x moveInAny _veh; } forEach units _crew;
	units _crew joinSilent _grp;
	if (_role == "supply") then {
		private _cargo = [_pos, (_veh emptyPositions "Cargo") min 8] call spo_fnc_createSquad;
		{ _x moveInCargo _veh; } forEach units _cargo;
		units _cargo joinSilent _grp;
		_supply pushBack _veh;
	};
	_veh setVariable ["spo_convoy_role", _role];
	_veh lock 2;
	_vehicles pushBack _veh;
} forEach _plan;
_grp selectLeader (effectiveCommander (_vehicles # 0));
_grp setFormation "COLUMN";
_grp setBehaviour "SAFE";
_grp setSpeedMode "LIMITED";
{ _x disableAI "AUTOCOMBAT"; } forEach units _grp;
// troops may bail out when attacked, crews stay with their vehicles
{ _x setUnloadInCombat [true, false]; } forEach _vehicles;

private _departAt = time + 240 + random 180;
private _dirs = ["north", "north-east", "east", "south-east", "south", "south-west", "west", "north-west"];
private _dirName = { _dirs # ((round ((spo_centerPos getDir _this) / 45)) mod 8) };
private _mkr = createMarker ["spo_convoy_start", _start];
_mkr setMarkerTypeLocal "mil_start";
_mkr setMarkerTextLocal "Convoy staging";
_mkr setMarkerColor "ColorEAST";
_mkr = createMarker ["spo_convoy_end", _end];
_mkr setMarkerTypeLocal "mil_end";
_mkr setMarkerTextLocal "Convoy exit";
_mkr setMarkerColor "ColorEAST";

private _minutes = round ((_departAt - time) / 60);
private _desc = format ["An enemy supply convoy (%1 vehicles, %2 supply truck%3 carrying troops) is staging on the %4 road. It leaves in about %5 minutes and drives through the objective to the %6 exit. Stop every supply truck before it gets there. The escorts will push through an ambush and the troops will dismount to fight.", count _vehicles, count _supply, ["", "s"] select (count _supply > 1), _start call _dirName, _minutes, _end call _dirName];
private _task = [blufor, "spo_convoy_task", [_desc, "Ambush the supply convoy", ""], _via, "AUTOASSIGNED", 0, true, "car"] call BIS_fnc_taskCreate;
format ["Intel: enemy supply convoy leaves the %1 road in about %2 minutes, heading %3.", _start call _dirName, _minutes, _end call _dirName] remoteExec ["hint", 0];

_this setVariable ["spo_convoy_group", _grp];
_this setVariable ["spo_convoy_vehicles", _vehicles];
_this setVariable ["spo_convoy_supply", _supply];
_this setVariable ["spo_convoy_route", [_via, _end]];
_this setVariable ["spo_convoy_start", _start];
_this setVariable ["spo_convoy_departAt", _departAt];
_this setVariable ["spo_convoy_task", _task];
_this setVariable ["spo_convoy_speed", 45];
