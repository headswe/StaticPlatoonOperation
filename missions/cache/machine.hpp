class SPO_Cache_MissionStateMachine {
	displayName = "Cachehunt";
	list = "[spo_namespace]";
	class Startup {
		onStateEntered = "spo_fnc_onCacheStart";
	};
};