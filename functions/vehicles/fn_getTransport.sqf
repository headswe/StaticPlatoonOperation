private _vehicles = ((spo_factionsVehicles getVariable [spo_vehicleFaction, []]) # 2) select {
    ((configName _x) isKindOf "LandVehicle") && 
    {!((configName _x) isKindOf "StaticWeapon") } && {!((_x >> "artilleryScanner") call BIS_fnc_getCfgDataBool)} && 
	{ getNumber (_x >> 'transportSoldier') >= 4} &&
    {!((_x >> "isUav") call BIS_fnc_getCfgDataBool)}
};
_vehicles