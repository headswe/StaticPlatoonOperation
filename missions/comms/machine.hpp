// Comms tower: while the tower stands and the enemy is in contact, new squads keep arriving from the road entries.
// Players sabotage it (hold action, then a short fuse) or blow it up to stop the waves and break enemy morale.
class SPO_Comms_MissionStateMachine {
	displayName = "Comms tower";
	list = "[spo_namespace]";
	class Startup {
		onStateEntered = "spo_fnc_onCommsStart";
		class Started {
			condition = "true";
			targetState = "TowerStanding";
		};
	};
	class TowerStanding {
		class Destroyed {
			condition = "!alive (_this getVariable ['spo_comms_tower', objNull]) || {spo_commsDown}";
			targetState = "Destroyed";
		};
		class Wave {
			condition = "spo_fnc_commsWaveDue";
			targetState = "TowerStanding";
			onTransition = "spo_fnc_commsWave";
		};
	};
	class Destroyed {
		onStateEntered = "spo_fnc_onCommsDestroyed";
	};
};
