// Sorts a CfgVehicles entry into a setup-dialog vehicle type: "car", "apc", "tank", "heli", or "" for anything else.
// Uses the Eden editor subcategory when the vehicle has a standard one, otherwise falls back to its inheritance.
params ["_cfg"];
private _class = configName _cfg;
if (_class isKindOf "Helicopter") exitWith {"heli"};
if (!(_class isKindOf "LandVehicle")) exitWith {""};
private _tracked = _class isKindOf "Tank";
switch (getText (_cfg >> "editorSubcategory")) do {
	case "EdSubcat_Tanks": {"tank"};
	case "EdSubcat_APCs": {"apc"};
	case "EdSubcat_AAs": { ["apc", "tank"] select _tracked };
	case "EdSubcat_Cars": {"car"};
	default {
		switch (true) do {
			case (_tracked): { ["tank", "apc"] select (getNumber (_cfg >> "transportSoldier") >= 4) };
			case (_class isKindOf "Wheeled_APC_F"): {"apc"};
			default {"car"};
		};
	};
};
