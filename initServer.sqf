clearItemCargoGlobal spo_supply_box;
//spo_supply_box addItemCargoGlobal ["ACE_wirecutter", 20];
[] spawn {
    sleep 3;
    enemyDoll switchMove "HubBriefing_loop";
};
sleep 0.1;
[] spawn spo_fnc_getViableFactions;