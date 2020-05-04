// Setup units.
private _hunters = [];
private _oldGroups = [];
{
    private _grp = _x;
    _oldGroups pushBackUnique _grp;
    {
        private _unit = _x;
        _hunters pushBackUnique _unit;
        [_unit] joinSilent grpNull;
        _unit setUnitPos "UP";
        _unit disableAI "SUPPRESSION";
        _unit disableAI "AUTOCOMBAT"; // Already applied at init but reapply.
        _unit setBehaviour "AWARE";
        _unit setSpeedMode "FULL";

        // Just in case MM went crazy.
        _unit enableAI "PATH";
        _unit enableAI "MOVE";

        _unit allowFleeing 0;
        doStop _unit;
        
    } forEach units _grp;
} forEach (spo_garrison_groups + spo_patrol_groups);

// Cleanup groups no longer used.
{
    if (count (units _x) == 0) then {deleteGroup _x;};
} forEach (_oldGroups - [grpNull]);

// Spawn for performance reasons.
[_hunters, blufor, spo_centerPos, spo_perimeter_radius] spawn tmf_ai_fnc_huntLoop;