class missionSetuipDialog: RscControlsGroup
{
	idd = 2300;
	x = 0.293679 * safezoneW + safezoneX;
	y = 0.246907 * safezoneH + safezoneY;
	w = 0.412642 * safezoneW;
	h = 0.374138 * safezoneH;
	onLoad="['onLoad', _this] call spo_fnc_missionSettingsDialog;";
	class Controls
	{
		class dialogBackground: IGUIBack
		{
			idc = 2200;
			x = 0 * safezoneW;
			y = 0 * safezoneH;
			w = 0.412642 * safezoneW;
			h = 0.374138 * safezoneH;
			colorBackground[] = {0.212,0.212,0.212,1};
		};
		class dialogHeader: IGUIBack
		{
			idc = 2220;
			x = 0 * safezoneW;
			y = 0 * safezoneH;
			w = 0.412642 * safezoneW;
			h = 0.015 * safezoneH;
			colorBackground[] = {0.169,0.89,0.494,1};
		};
		class dialogFrame: RscFrame
		{
			idc = 1800;
			x = 0 * safezoneW;
			y = 0 * safezoneH;
			w = 0.412642 * safezoneW;
			h = 0.374138 * safezoneH;
			color[] = {1,1,1,0.3};
		};
		class playerFactionLabel: RscText
		{
			idc = 1000;
			text = "Player faction"; //--- ToDo: Localize;
			x = 0.005 * safezoneW;
			y = 0.022 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class playerFactionCombo: RscCombo
		{
			idc = 2100;
			x = 0.01 * safezoneW;
			y = 0.044 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class enemyFactionLabel: RscText
		{
			idc = 1001;
			text = "Enemy faction"; //--- ToDo: Localize;
			x = 0.005 * safezoneW;
			y = 0.066 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class enemyFactionCombo: RscCombo
		{
			idc = 2101;
			x = 0.01 * safezoneW;
			y = 0.088 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class ratioSlider: RscCombo
		{
			idc = 1900;
			x = 0.01 * safezoneW;
			y = 0.132 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class ratioLabel: RscText
		{
			idc = 1002;
			text = "AI Ratio"; //--- ToDo: Localize;
			x = 0.005 * safezoneW;
			y = 0.11 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class vehicleFactionLabel: RscText
		{
			idc = 1003;
			text = "Enemies use vehicles from faction"; //--- ToDo: Localize;
			x = 0.005 * safezoneW;
			y = 0.154 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class vehicleFactionCombo: RscCombo
		{
			idc = 2003;
			x = 0.01 * safezoneW;
			y = 0.176 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class missionLabel: RscText
		{
			idc = 10044;
			text = "Mission"; //--- ToDo: Localize;
			x = 0.005 * safezoneW;
			y = 0.2 * safezoneH;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class missionCombo: RscCombo
		{
			idc = 2004;
			x = 0.304062 * safezoneW + safezoneX
			y = 0.456 * safezoneH + safezoneY;
			w = 0.2 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class aoMAP: RscMapControl
		{
			idc = 1801;
			x = 0.225 * safezoneW;
			y = 0.046219 * safezoneH;
			w = 0.185 * safezoneW;
			h = 0.27 * safezoneH;
		};
		class goButton: RscButton
		{
			idc = 1600;
			text = "Go"; //--- ToDo: Localize;
			x = 0.34043 * safezoneW;
			y = 0.330121 * safezoneH;
			w = 0.0618964 * safezoneW;
			h = 0.035 * safezoneH;
			colorBackground[] = {0.169,0.89,0.494,1};
			color[] = {1,1,1,1};
			onButtonClick="['done', _this] call spo_fnc_missionSettingsDialog;";
		};
	};
};