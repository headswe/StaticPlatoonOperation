params ["_pos"];
_pos set [2,2];
_flare = createVehicle ["F_40mm_Red", _pos, [],0,""];
_flare setVelocity [0,0,8]