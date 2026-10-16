// Win condition: every supply truck is destroyed or can no longer drive.
private _supply = _this getVariable ["spo_convoy_supply", []];
_supply isNotEqualTo [] && {_supply findIf {alive _x && {canMove _x}} == -1}
