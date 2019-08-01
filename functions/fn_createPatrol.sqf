

fn_createWaypoint = {
	params [
		"_group",
		"_position",
		["_radius", 0, [0]]
	];
	_group = _group call CBA_fnc_getGroup;
	private _initialPosition = _position call CBA_fnc_getPos;

	_position = _initialPosition vectorAdd [(random 2*_radius) - _radius,(random 2*_radius) - _radius,0];
	for "_i" from 1 to 100 do {
		if (!surfaceIsWater _position) exitWith {};
		_position = _initialPosition vectorAdd [(random 2*_radius) - _radius,(random 2*_radius) - _radius,0];
	};
	
	
	
	private _waypoint = _group addWaypoint [_position, 10];

	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointTimeout [3,6,9];
	_waypoint setWaypointCompletionRadius 5;

	_waypoint;
};

params ["_group", ["_position",[0,0,0]], ["_radius",100], ["_count",3]];

_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

_position = [_position,_group] select (_position isEqualTo []);
_position = _position call CBA_fnc_getPos;

// Clear existing waypoints first
[_group] call CBA_fnc_clearWaypoints;

private _this =+ _this;
switch (count _this) do {
    case 1 : {_this append [_position, _radius]};
    case 2 : {_this pushBack _radius};
    default {};
};
if (count _this > 3) then {
    _this deleteAt 3;
};

// Store first WP to close loop later
private _wp = _this call fn_createWaypoint;
_wp setWaypointBehaviour "SAFE";
for "_x" from 1 to (_count - 1) do {
    _this call fn_createWaypoint;
};

// Cycle

private _waypoint = _group addWaypoint [getWPPos _wp, 0];
_waypoint setWaypointType "CYCLE";

{_x setpos (waypointPosition _wp)} foreach units _group;