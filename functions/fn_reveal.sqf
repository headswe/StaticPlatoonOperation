params ["_grp", "_otherGrp"];
private _targets = ((leader _otherGrp) nearTargets 400) select {(_otherGrp knowsAbout _x # 4) > 0.1 };
{
	_grp reveal [_x # 4, (_grp knowsAbout _x # 4)];
} forEach _targets;