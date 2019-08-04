params ['_spawnPos', '_numberOfMen', ['_roles', ['r','r','r','ftl','aar','ar','rat']], ['_random', true]];

private _grp = createGroup east;
private _usedRoles = +_roles;
while {_numberOfMen > 0} do {
	private _role = 'r';
	if(_random) then {
		_role = selectRandom _roles;
	} else {
		if(count _usedRoles <= 0) then {
			_usedRoles = +_roles;
		};
		_role = _usedRoles deleteAt 0;
	};
	private _solider = _grp createUnit ['O_Soldier_F',_spawnPos,[],0,'NONE'];
	[_solider, _role] call dsm_fnc_gear;
	_numberOfMen = _numberOfMen - 1;
};
_grp;