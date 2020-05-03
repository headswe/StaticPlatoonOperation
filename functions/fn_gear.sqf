params ["_unit","_role"];


private _faction = spo_bluFaction;
if (side _unit == east) then { _faction = spo_opforFaction;};

if (_faction != "") then {
	_unit setVariable ["tmf_assignGear_faction",_faction];
};
if (!isNil "_role") then {
	_unit setVariable ["tmf_assignGear_role",_role];
};
private _faction = _unit getVariable ["tmf_assignGear_faction", toLower(faction _unit)];
private _role = _unit getVariable ["tmf_assignGear_role","r"];
_cfg = configFile >> "cfgLoadouts" >> _faction >> _role;
// if the faction dosent have role, change it.
if(!isClass _cfg) then {
	_unit setVariable ["tmf_assignGear_role",'r'];
};
_unit call tmf_assignGear_fnc_assignGear;