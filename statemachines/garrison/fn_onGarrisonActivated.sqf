// awake for good: dynamic simulation would freeze them again if players back off
_this enableDynamicSimulation false;
_this setBehaviour "COMBAT";
_this setCombatMode "RED";

private _data = _this getVariable ["spo_garrisonData", []];
private _targets = ((playableUnits + switchableUnits) select {side _x == blufor}) inAreaArray _data;
{
	_this reveal _x;
} forEach _targets;
_this call spo_fnc_requestReinforcement;

// most of the garrison holds the building; only a few (max 3) leave to hunt
private _units = (units _this) select {alive _x};
[_units, true] call CBA_fnc_shuffle;
private _hunters = _units select [0, (floor (count _units / 3)) min 3];
{
	_x setUnitPos "AUTO";
} forEach (_units - _hunters);

if (_hunters isEqualTo []) exitWith {};
private _huntGrp = createGroup [east, true];
_hunters joinSilent _huntGrp;
_huntGrp enableDynamicSimulation false;
{
	_x enableAI "PATH";
	_x setUnitPos "AUTO";
} forEach _hunters;
{
	_huntGrp reveal _x;
} forEach _targets;
private _huntPos = if (_targets isEqualTo []) then { _data # 0 } else { getPosATL (_targets # 0) };
[_huntGrp, _huntPos, 0, "SAD", "COMBAT", "RED", "FULL", "LINE"] call CBA_fnc_addWaypoint;
