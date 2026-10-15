// Land vehicles from the selected vehicle faction that can carry a squad (armed or not).
private _vehicles = ((spo_factionsVehicles getOrDefault [spo_vehicleFaction, [nil, nil, []]]) # 2) select {
    ((configName _x) isKindOf "LandVehicle") && {([_x] call spo_fnc_vehicleCategory) in spo_vehicleTypes} && 
    {!((configName _x) isKindOf "StaticWeapon") } && {!((_x >> "artilleryScanner") call BIS_fnc_getCfgDataBool)} && 
	{ getNumber (_x >> 'transportSoldier') >= 4} &&
    {!((_x >> "isUav") call BIS_fnc_getCfgDataBool)}
};
_vehicles
