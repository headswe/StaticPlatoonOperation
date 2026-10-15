// State machine condition: the HVT's group is in combat, or players are right at the building.
private _hvt = _this getVariable ["spo_hvt", objNull];
alive _hvt && {
	behaviour _hvt == "COMBAT" ||
	{(units blufor inAreaArray [getPos _hvt, 35, 35, 0, false]) isNotEqualTo []}
}
