_checkWeapons = {
    private _weapons = [configName _this] call BIS_fnc_weaponsEntityType;
    {
        !(
            (_x isKindOf ["FakeWeapon", configfile >> "cfgWeapons"]) ||
            (_x isKindOf  ["CarHorn", configfile >> "cfgWeapons"]) || 
            (_x isKindOf  ["SmokeLauncher", configfile >> "cfgWeapons"]) || 
            (_x isKindOf  ["Laserdesignator_mounted", configfile >> "cfgWeapons"])
        )
    } count _weapons
};

_checkThreat = {
    private _threat = (_this >> 'threat') call BIS_fnc_getCfgDataArray;
    _threat params ["_men", "_vehicle", "_air"];
    if(_air >= 0.9) exitWith {
        _men > 0.7
    };
    true
};


private _vehicles = ((dsm_factionsVehicles getVariable [dsm_vehicleFaction, []]) # 2) select {
    ((configName _x) isKindOf "LandVehicle") && 
    {!((configName _x) isKindOf "StaticWeapon") } && 
    {(_x call _checkWeapons) > 0} &&
    {_x call _checkThreat} &&
    {!((_x >> "isUav") call BIS_fnc_getCfgDataBool)}
};
_vehicles