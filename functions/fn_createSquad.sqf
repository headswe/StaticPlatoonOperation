params ['_spawnPos', '_numberOfMen', ['_roles', spo_allowedRoles], ['_random', true]];
private _grp = createGroup [east, true];
_grp allowFleeing 0;
private _usedRoles = +_roles;
while {_numberOfMen > 0} do {
	private _role = 'r';
	if(_random) then {
		_role =  _roles selectRandomWeighted [0.33, 0.2,0.1, 0.15, 0.25, 0.25, 0.05, 0.1, 0.01, 0.01, 0.1];
	} else {
		if(count _usedRoles <= 0) then {
			_usedRoles = +_roles;
		};
		_role = _usedRoles deleteAt 0;
	};
	private _solider = _grp createUnit ['O_Soldier_F',[_spawnPos # 0, _spawnPos # 1, 0],[],5,'NONE'];
	[_solider, selectRandom spo_speakers] remoteExec ["setIdentity", 0, _solider];
	_solider setSkill (random [0.5,0.7,1]);
	[_solider, _role] call spo_fnc_gear;
	_numberOfMen = _numberOfMen - 1;
};
_grp;

