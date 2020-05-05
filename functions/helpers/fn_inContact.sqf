private _grp = _this;

private _targets = ((leader _grp) nearTargets 400) select {(_x#2) == blufor && (leader _grp knowsAbout _x # 4) > 0.5 };
count _targets > 0
