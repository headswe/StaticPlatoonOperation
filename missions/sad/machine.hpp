class SPO_SAD_MissionStateMachine {
	displayName = "Search and destroy";
	list = "[spo_mission_object]";
	class Startup {
		onStateEntered = "spo_fnc_onSadStart";

		class Victory {
			condition="(_this getVariable ['spo_enemyCount',0]) >= (count (allUnits select {side _x == EAST}))";
			targetState = "Win";
		}
	};
	class Win {
		onStateEntered="spo_fnc_onSadEnd"
	};

};