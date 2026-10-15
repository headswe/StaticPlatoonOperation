// Convoy ambush: an enemy supply convoy waits at one road entry and drives through the objective to the far one.
// Players pick an ambush spot. Stopping every supply truck wins; a supply truck reaching the exit loses.
// Convoy handling follows the public convoy scripts: one group in COLUMN, limitSpeed and setConvoySeparation on
// every vehicle (only the leader respects the group speed), and a watchdog that re-forms stuck vehicles.
class SPO_Convoy_MissionStateMachine {
	displayName = "Convoy ambush";
	list = "[spo_namespace]";
	class Startup {
		onStateEntered = "spo_fnc_onConvoyStart";
		class Started {
			condition = "true";
			targetState = "Waiting";
		};
	};
	class Waiting {
		class Stopped {
			condition = "spo_fnc_convoyStopped";
			targetState = "Stopped";
		};
		class Depart {
			condition = "spo_fnc_convoyDepartDue";
			targetState = "Moving";
			onTransition = "spo_fnc_onConvoyDepart";
		};
	};
	class Moving {
		onState = "spo_fnc_convoyWatchdog";
		class Stopped {
			condition = "spo_fnc_convoyStopped";
			targetState = "Stopped";
		};
		class Escaped {
			condition = "spo_fnc_convoyEscaped";
			targetState = "Escaped";
		};
		class Ambushed {
			condition = "!(_this getVariable ['spo_convoy_ambushed', false]) && {_this call spo_fnc_convoyUnderAttack}";
			targetState = "Moving";
			onTransition = "spo_fnc_onConvoyAmbushed";
		};
	};
	class Stopped {
		onStateEntered = "['stopped'] call spo_fnc_onConvoyEnd";
	};
	class Escaped {
		onStateEntered = "['escaped'] call spo_fnc_onConvoyEnd";
	};
};
