private _grp = _this;

private _targets = ((leader _grp) nearTargets 400) select {
    _x params ["_pos","_type", "_side", "_cost", "_object", "_acc"];
    side _object == blufor && {_grp knowsAbout _object >= 2}
};
count _targets > 0
