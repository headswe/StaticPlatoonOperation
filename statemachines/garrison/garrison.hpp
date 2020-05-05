class SPO_GarrisonStateMachine {
	list = "spo_garrison_groups";
	skipNull = 1;

	class Garrisoned {
		class Activate {
			targetState = "Activated";
			condition = "spo_fnc_shouldActivateGarrison";
		};
	};

	class Activated {
		onStateEntered = "spo_fnc_onGarrisonActivated"
	};
};