// State machine condition: time for the next wave, enemy groups in contact, manpower left and the AI count sane.
(time >= (_this getVariable ["spo_comms_nextWave", 0])) &&
{(_this getVariable ["spo_comms_budget", 0]) > 0} &&
{count (units east) < 150} &&
{spo_reinforcement_locations isNotEqualTo []} &&
{(spo_patrol_groups + spo_garrison_groups) findIf {!isNull _x && {alive leader _x} && {_x call spo_fnc_inContact}} != -1}
