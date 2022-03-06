private _numberOfCaches = floor random 4;
private _caches = [];
([spo_centerPos, spo_objective_radius] call spo_fnc_nearBuildings) params ["_buildings"];
_buildings = _buildings select {count (_x # 0) > 0};


for "_i" from 0 to _numberOfCaches do {
    private _cache = objNull;
    private _task = [blufor, format ["stc_%1", _i], [format ["Cache %1", _i],format ["Cache %1", _i], ""], objNull , "AUTOASSIGNED", 0, true, "destroy"] call BIS_fnc_taskCreate;
    if(count _buildings > 0) then {
        (selectRandom _buildings) params ["_poses", "_building"];
        private _pos = selectRandom _poses;
        _cache = createVehicle ["Box_FIA_Wps_F", _pos, [], 0, "CAN_COLLIDE"];
        _poses = _poses - [_pos];
        if (count _poses >= 1) then {
            private _unitsToSpawn = (count _posses) - 1;
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
        };
    } else {
        private _pos = [spo_perimeter_mkrName] call CBA_fnc_randPosArea;
        _cache = createVehicle ["Box_FIA_Wps_F", _pos, [], 0];
        "Campfire_burning_F" createVehicle _pos;
        [_pos] call spo_fnc_createGuardPoint;
    };
    _cache setVariable ["task", _task];
    _caches pushBack _cache;
    _cache addEventHandler ["killed", {
        private _task = _this getVariable ["task", nil];
        [_task, "SUCCEEDED"] call BIS_fnc_taskSetState;
    }];
};
_this setVariable ["caches", _caches];