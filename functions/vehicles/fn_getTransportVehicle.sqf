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

private _vehicles = ((spo_factionsVehicles getVariable [spo_vehicleFaction, []]) # 2) select {
    ((configName _x) isKindOf "LandVehicle") && 
    {!((configName _x) isKindOf "StaticWeapon") } && {!((_x >> "artilleryScanner") call BIS_fnc_getCfgDataBool)} && 
        {(_x call _checkWeapons) > 0} &&
	{ getNumber (_x >> 'transportSoldier') >= 4} &&
    {!((_x >> "isUav") call BIS_fnc_getCfgDataBool)}
};
_vehicles