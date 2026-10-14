private _data = _this getVariable ["spo_garrisonData", []];
(count ((allPlayers select {side _x == blufor}) inAreaArray _data)) > 0 && (random 1) >= 0.5;
