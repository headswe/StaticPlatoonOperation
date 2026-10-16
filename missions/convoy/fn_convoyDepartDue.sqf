// State machine condition: departure time, or players found the staging area (the convoy bolts early).
(time >= (_this getVariable ["spo_convoy_departAt", 0])) ||
{(units blufor inAreaArray [_this getVariable ["spo_convoy_start", [0,0,0]], 250, 250, 0, false]) isNotEqualTo []} ||
{_this call spo_fnc_convoyUnderAttack}
