params ["_pos"];
_pos set [2,100];
_flare = createVehicle ["F_40mm_Red", _pos, [],0,""];
_flare setVelocity [0,0,-0.3]