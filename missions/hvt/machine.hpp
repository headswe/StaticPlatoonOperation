// HVT: an officer hides in a building near the objective. Once alerted he runs for a car and drives out
// along one of the reinforcement roads. Capture (ACE handcuffs) and extract him, or kill him.
class SPO_HVT_MissionStateMachine {
	displayName = "HVT capture or kill";
	list = "[spo_namespace]";
	class Startup {
		onStateEntered = "spo_fnc_onHvtStart";
		class Killed {
			condition = "!alive (_this getVariable ['spo_hvt', objNull])";
			targetState = "Killed";
		};
		class Captured {
			condition = "(_this getVariable ['spo_hvt', objNull]) getVariable ['ace_captives_isHandcuffed', false]";
			targetState = "Captured";
		};
		class Alerted {
			condition = "spo_fnc_hvtAlerted";
			targetState = "Fleeing";
		};
	};
	class Fleeing {
		onStateEntered = "spo_fnc_onHvtFlee";
		class Killed {
			condition = "!alive (_this getVariable ['spo_hvt', objNull])";
			targetState = "Killed";
		};
		class Captured {
			condition = "(_this getVariable ['spo_hvt', objNull]) getVariable ['ace_captives_isHandcuffed', false]";
			targetState = "Captured";
		};
		class Escaped {
			condition = "((_this getVariable ['spo_hvt', objNull]) distance2D (_this getVariable ['spo_hvt_escapePos', [0,0,0]])) < 75";
			targetState = "Escaped";
		};
	};
	class Captured {
		onStateEntered = "spo_fnc_onHvtCaptured";
		class Killed {
			condition = "!alive (_this getVariable ['spo_hvt', objNull])";
			targetState = "Killed";
		};
		class Extracted {
			condition = "((_this getVariable ['spo_hvt', objNull]) distance2D spo_centerPos) > spo_perimeter_radius";
			targetState = "Extracted";
		};
	};
	class Killed {
		onStateEntered = "['killed'] call spo_fnc_onHvtEnd";
	};
	class Extracted {
		onStateEntered = "['extracted'] call spo_fnc_onHvtEnd";
	};
	class Escaped {
		onStateEntered = "['escaped'] call spo_fnc_onHvtEnd";
	};
};
