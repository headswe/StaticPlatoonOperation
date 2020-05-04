/// 
([spo_centerPos, spo_objective_radius] call spo_fnc_nearBuildings) params ["_buildings"];
_buildings = _buildings select {count (_x # 0) > 2};
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




