params ["_unit","_role"];


private _faction = dsm_bluFaction;
if (side _unit == east) then { _faction = dsm_opforFaction;};

if (_faction != "") then {
	_unit setVariable ["tmf_assignGear_faction",_faction];
};
if (!isNil "_role" && _role != "r") then {
	_unit setVariable ["tmf_assignGear_role",_role];
};
// Workaround for EDEN.
if (is3DEN) then {
	_unit spawn {
		[tmf_assignGear_fnc_assignGear,_this] call CBA_fnc_directCall;
	};
} else {
	_unit call tmf_assignGear_fnc_assignGear;
};