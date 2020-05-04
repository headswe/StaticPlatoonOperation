class SPO_Secure_MissionStateMachine {
	name = "Secure";
	list = "[spo_mission_object]";
	class Startup {
		onStateEntered = "spo_fnc_onSecureStart";

		class playersNear {
			condition="{side _x == blufor} count ((getPos (_this getVariable ['spo_secure_building', objNull])) nearEntities 50) >= 1 && {side _x == opfor} count ((getPos (_this getVariable ['spo_secure_building', objNull])) nearEntities 30) <= 0";
			targetState = "PlayersArrived";
		}
	}
	class PlayersArrived {
		onStateEntered="spo_fnc_onSecureArrived";
		class waveDefeated {
			condition="({units _x > 0} count spo_attack_wave) <= 0";
		}
	}
	class Win {
		onStateEntered="spo_fnc_onSecureWin"
	}

}