class SPO_PatrolStateMachine {
	list = "spo_patrol_groups select {({alive _x} count (units _x)) > 0}";
	skipNull = 1;
	class Initial {
        onState = "";
        onStateEntered = "";
        onStateLeaving = "";

		class OnContact {
			targetState = "Combat";
			condition = "spo_fnc_inContact";
		};
		class ReinforcementRequestRecived {
			targetState = "MovingToReinforcementLocation";
			condition = "!isNull (_this getVariable ['spo_reinforceing', grpNull])";
		};
	};

	class MovingToReinforcementLocation {
		onStateEntered = "spo_fnc_onReinforceing";
		onStateLeaving = "systemChat 'Group arrived at location'";
		class Arrived {
			targetState = "Reinforceing";
			condition = "_this getVariable ['spo_reinforcement_location',getpos (leader _this)] distance (leader _this) <= 10";
		};
	};

	class Reinforceing {
		onStateEntered="[_this, _this getVariable ['spo_reinforceing', this]] call spo_fnc_reveal";
		class SearchCompletedNoTargets {
			targetState = "Initial";
			// if finished searching and no contacts, go back to normal
			condition = "isNull (_this getVariable ['spo_reinforceing', grpNull]) && !(_this call spo_fnc_inContact)";
		};
		class SearchCompleted {
			targetState = "Initial"; // add SearchAndDestory
			// if finished SAD waypoint and have targets.
			condition = "isNull (_this getVariable ['spo_reinforceing', grpNull]) && !(_this call spo_fnc_inContact)";
			onStateLeaving ="[_this, getpos leader _this, 1, 4, random [100,200,250], true] call spo_fnc_patrol";
		};
	};

	class SearchAndDestory {
        onStateEntered = "";
	};

	class Combat {
        onStateEntered = "systemChat 'Entered Combat'";
		class NoContacs {
			targetState = "Initial";
			condition = "!(_this call spo_fnc_inContact)";
			onStateLeaving ="[_this, getpos leader _this, 1, 4, random [100,200,250], true] call spo_fnc_patrol";
		};
		class RequestReinforcement  {
			targetState = "RequestReinforcement";
			// can call reinforcement every 15 seconds
			condition = "time - (_this getVariable ['spo_reinforcement_called', 0]) > 20";
		};
	};

	class RequestReinforcement {
		onStateEntered = "spo_fnc_requestReinforcement";
		class Done {
			targetState = "Combat";
			condition = "true";
		};
	};
};