// Lose condition: a working supply truck reached the exit.
private _end = (_this getVariable ["spo_convoy_route", [[0,0,0], [0,0,0]]]) # 1;
(_this getVariable ["spo_convoy_supply", []]) findIf {alive _x && {canMove _x} && {(_x distance2D _end) < 120}} != -1
