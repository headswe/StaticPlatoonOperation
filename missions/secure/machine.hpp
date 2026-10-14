class SPO_Secure_MissionStateMachine {
	displayName = "Secure";
	list = "[spo_namespace]";
	class Startup {
		onStateEntered = "spo_fnc_onSecureStart";

		class playersNear {
			condition="private _pos = getPos (_this getVariable ['spo_secure_building', objNull]); (units blufor inAreaArray [_pos, 50, 50, 0, false]) isNotEqualTo [] && {((units opfor select {alive _x}) inAreaArray [_pos, 30, 30, 0, false]) isEqualTo []}";
			targetState = "PlayersArrived";
		};
	};
	class PlayersArrived {
		onStateEntered="spo_fnc_onSecureArrived";
		class waveDefeated {
			condition="({count units _x > 0} count spo_attack_wave) <= 0";
			targetState = "Win";
		};
	};
	class Win {
		onStateEntered="spo_fnc_onSecureWin"
	};

};