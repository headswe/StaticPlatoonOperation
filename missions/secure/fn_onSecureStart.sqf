/// 
([spo_centerPos, spo_objective_radius] call spo_fnc_nearBuildings) params ["_buildings"];
_buildings = _buildings select {count (_x # 0) > 3};
private _building = objNull;
if(count _buildings <= 0) then {
    private _spot = spo_centerPos findEmptyPosition [0,  spo_objective_radius, "Land_Cargo_HQ_V1_F"];
    _building = "Land_Cargo_HQ_V1_F" createVehicle _spot;
} else {
    _building = (selectRandom _buildings) # 1;
};

private _task = [blufor, "spo_secure_task", ["Secure Building","Secure the building", ""], getpos _building, "AUTOASSIGNED", 0, true, "secure"] call BIS_fnc_taskCreate;
_this setVariable ["spo_secure_task", _task];
_this setVariable ["spo_secure_building", _building];
private _posses = _building buildingPos -1;
private _unitsToSpawn = (count _posses-1) min 10;
_garrisonGrp = createGroup [opfor, true];
for "_i" from 0 to _unitsToSpawn do {
    private _solider = _garrisonGrp createUnit ['O_Soldier_F',[0,0,0],[],0,'NONE'];
    [_solider, selectRandom spo_speakers] remoteExec ["setIdentity", 0, _solider];
    private _role = selectRandom spo_allowedRoles;
    _solider setPos _posses # _i;
    [_solider, _role] call spo_fnc_gear;
    _solider disableAI 'PATH'; 
    _solider setUnitPos 'UP';
};
_building setVariable ['spo_garrison_group', _garrisonGrp];