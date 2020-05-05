params ["_pos", ["_alt", 2]];
_pos set [2,_alt];
_flare = createVehicle ["F_40mm_Red", _pos, [],0,""];
_flare setVelocity [0,0,8]