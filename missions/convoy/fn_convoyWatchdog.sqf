// Runs every state machine tick while the convoy moves, throttled to every 2 s.
// Every vehicle gets the speed cap and spacing (the group only applies them to its leader), and a vehicle
// that has stood still for 15 s is told to rejoin the column. A stalled lead vehicle gets its waypoint re-issued.
if (time < (_this getVariable ["spo_convoy_nextCheck", 0])) exitWith {};
_this setVariable ["spo_convoy_nextCheck", time + 2];
private _grp = _this getVariable ["spo_convoy_group", grpNull];
if (isNull _grp || {!alive leader _grp}) exitWith {};
private _speed = _this getVariable ["spo_convoy_speed", 45];
private _leadVeh = vehicle leader _grp;
// heads-up when the column is about two minutes from the objective
if (!(_this getVariable ["spo_convoy_warned", false]) && {(_leadVeh distance2D ((_this getVariable ["spo_convoy_route", [[0,0,0]]]) # 0)) < 1000}) then {
	_this setVariable ["spo_convoy_warned", true];
	"Convoy about two minutes out from the objective." remoteExec ["hint", 0];
};
{
	_x limitSpeed _speed;
	_x setConvoySeparation ([40, 60] select (_speed > 50));
	if (speed _x < 3) then {
		private _since = _x getVariable ["spo_convoy_stuckSince", time];
		_x setVariable ["spo_convoy_stuckSince", _since];
		if (time - _since > 15) then {
			_x setVariable ["spo_convoy_stuckSince", time];
			if (_x == _leadVeh) then {
				_grp setCurrentWaypoint [_grp, currentWaypoint _grp];
			} else {
				(driver _x) doFollow leader _grp;
			};
		};
	} else {
		_x setVariable ["spo_convoy_stuckSince", nil];
	};
} forEach ((_this getVariable ["spo_convoy_vehicles", []]) select {alive _x && {canMove _x} && {alive driver _x}});
