// Mission setup dialog. Opened by the "Setup mission" action in mission.sqm, so the class name must stay.
// Positions are generated as fractions of the safe zone; logic lives in functions\fn_missionSettingsDialog.sqf.

#define SPO_COL_ACCENT {0.169,0.89,0.494,1}
#define SPO_COL_DARK {0.07,0.08,0.09,0.97}
#define SPO_COL_BODY {0.13,0.14,0.15,0.95}
#define SPO_COL_FIELD {0,0,0,0.45}
#define SPO_COL_BLU {0.35,0.62,1,1}
#define SPO_COL_OP {0.95,0.32,0.3,1}
#define SPO_TEXT_SIZE "0.022 * safezoneH"
#define SPO_SMALL_SIZE "0.019 * safezoneH"

class spo_RscBack: IGUIBack
{
	colorBackground[] = SPO_COL_BODY;
};
class spo_RscText: RscText
{
	font = "RobotoCondensed";
	sizeEx = SPO_TEXT_SIZE;
	shadow = 0;
};
class spo_RscSmall: spo_RscText
{
	sizeEx = SPO_SMALL_SIZE;
	colorText[] = {1,1,1,0.55};
};
class spo_RscLabel: spo_RscText
{
	font = "PuristaMedium";
	sizeEx = SPO_SMALL_SIZE;
	colorText[] = SPO_COL_ACCENT;
};
class spo_RscTitle: spo_RscText
{
	font = "PuristaBold";
	sizeEx = "0.036 * safezoneH";
	colorText[] = {1,1,1,1};
};
class spo_RscEdit: RscEdit
{
	font = "RobotoCondensed";
	sizeEx = SPO_TEXT_SIZE;
	colorBackground[] = SPO_COL_FIELD;
	colorBorder[] = {1,1,1,0.15};
};
class spo_RscListBox: RscListBox
{
	sizeEx = SPO_TEXT_SIZE;
	rowHeight = "0.026 * safezoneH";
	colorBackground[] = SPO_COL_FIELD;
	colorSelect[] = {0,0,0,1};
	colorSelect2[] = {0,0,0,1};
	colorSelectRight[] = {0,0,0,1};
	colorSelect2Right[] = {0,0,0,1};
	colorTextRight[] = {1,1,1,0.5};
	colorSelectBackground[] = SPO_COL_ACCENT;
	colorSelectBackground2[] = SPO_COL_ACCENT;
};
class spo_RscCombo: RscCombo
{
	font = "RobotoCondensed";
	sizeEx = SPO_TEXT_SIZE;
	colorBackground[] = {0.1,0.11,0.12,1};
	colorSelectBackground[] = SPO_COL_ACCENT;
	colorSelect[] = {0,0,0,1};
};
class spo_RscSlider: RscSlider
{
	color[] = {1,1,1,0.6};
	colorActive[] = SPO_COL_ACCENT;
};
class spo_RscCheckBox: RscCheckBox
{
	colorFocused[] = SPO_COL_ACCENT;
	colorHover[] = SPO_COL_ACCENT;
};
class spo_RscPicture: RscPicture
{
	style = 48;
	colorText[] = {1,1,1,1};
};
class spo_RscProgress
{
	type = 8;
	style = 0;
	idc = -1;
	x = 0;
	y = 0;
	w = 0.1;
	h = 0.01;
	shadow = 0;
	colorFrame[] = {1,1,1,0.25};
	colorBar[] = SPO_COL_ACCENT;
	texture = "#(argb,8,8,3)color(1,1,1,1)";
};
class spo_RscButton: RscButton
{
	font = "PuristaMedium";
	sizeEx = SPO_TEXT_SIZE;
	shadow = 0;
	colorBackground[] = {1,1,1,0.12};
	colorBackgroundActive[] = {1,1,1,0.25};
	colorFocused[] = {1,1,1,0.25};
};
class spo_RscButtonAccent: spo_RscButton
{
	font = "PuristaBold";
	colorText[] = {0,0,0,1};
	colorBackground[] = SPO_COL_ACCENT;
	colorBackgroundActive[] = {0.4,1,0.65,1};
	colorFocused[] = {0.4,1,0.65,1};
	colorBackgroundDisabled[] = {0.3,0.3,0.3,1};
};

class missionSetuipDialog
{
	idd = 2300;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = "['onLoad', _this] call spo_fnc_missionSettingsDialog";
	onUnload = "['onUnload', _this] call spo_fnc_missionSettingsDialog";
	class ControlsBackground
	{
		class spoDim: spo_RscBack
		{
			idc = -1;
			x = "safezoneX";
			y = "safezoneY";
			w = "safezoneW";
			h = "safezoneH";
			colorBackground[] = {0,0,0,0.55};
		};
		class spoBody: spo_RscBack
		{
			idc = -1;
			x = "0.1500 * safezoneW + safezoneX";
			y = "0.1850 * safezoneH + safezoneY";
			w = "0.7000 * safezoneW";
			h = "0.6450 * safezoneH";
			colorBackground[] = SPO_COL_BODY;
		};
		class spoHeader: spo_RscBack
		{
			idc = -1;
			x = "0.1500 * safezoneW + safezoneX";
			y = "0.1200 * safezoneH + safezoneY";
			w = "0.7000 * safezoneW";
			h = "0.0650 * safezoneH";
			colorBackground[] = SPO_COL_DARK;
		};
		class spoHeaderStripe: spo_RscBack
		{
			idc = -1;
			x = "0.1500 * safezoneW + safezoneX";
			y = "0.1200 * safezoneH + safezoneY";
			w = "0.0040 * safezoneW";
			h = "0.0650 * safezoneH";
			colorBackground[] = SPO_COL_ACCENT;
		};
		class spoHeaderLine: spo_RscBack
		{
			idc = -1;
			x = "0.1500 * safezoneW + safezoneX";
			y = "0.1830 * safezoneH + safezoneY";
			w = "0.7000 * safezoneW";
			h = "0.0020 * safezoneH";
			colorBackground[] = SPO_COL_ACCENT;
		};
		class spoFooter: spo_RscBack
		{
			idc = -1;
			x = "0.1500 * safezoneW + safezoneX";
			y = "0.8300 * safezoneH + safezoneY";
			w = "0.7000 * safezoneW";
			h = "0.0500 * safezoneH";
			colorBackground[] = SPO_COL_DARK;
		};
		class spoPreviewBackBlu: spo_RscBack
		{
			idc = -1;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.2560 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.3400 * safezoneH";
			colorBackground[] = SPO_COL_DARK;
		};
		class spoPreviewBackOp: spo_RscBack
		{
			idc = -1;
			x = "0.4875 * safezoneW + safezoneX";
			y = "0.2560 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.3400 * safezoneH";
			colorBackground[] = SPO_COL_DARK;
		};
	};
	class Controls
	{
		class spoTitle: spo_RscTitle
		{
			idc = -1;
			x = "0.1620 * safezoneW + safezoneX";
			y = "0.1240 * safezoneH + safezoneY";
			w = "0.4000 * safezoneW";
			h = "0.0380 * safezoneH";
			text = "STATIC PLATOON OPS";
		};
		class spoSubtitle: spo_RscLabel
		{
			idc = -1;
			x = "0.1630 * safezoneW + safezoneX";
			y = "0.1590 * safezoneH + safezoneY";
			w = "0.3000 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "MISSION SETUP";
		};
		class spoStatus: spo_RscText
		{
			idc = 1002;
			x = "0.4900 * safezoneW + safezoneX";
			y = "0.1400 * safezoneH + safezoneY";
			w = "0.3500 * safezoneW";
			h = "0.0300 * safezoneH";
			style = 1;
			text = "";
		};
		class playerFactionLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.1930 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "PLAYER FACTION";
		};
		class playerFactionSearch: spo_RscEdit
		{
			idc = 2110;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.2170 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0260 * safezoneH";
			tooltip = "Type to filter by name or category";
			onKeyUp = "['filter', _this] call spo_fnc_missionSettingsDialog";
		};
		class playerFactionList: spo_RscListBox
		{
			idc = 2100;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.2470 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.1500 * safezoneH";
			onLBSelChanged = "['select', _this] call spo_fnc_missionSettingsDialog";
		};
		class enemyFactionLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.4070 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "ENEMY FACTION";
		};
		class enemyFactionSearch: spo_RscEdit
		{
			idc = 2111;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.4310 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0260 * safezoneH";
			tooltip = "Type to filter by name or category";
			onKeyUp = "['filter', _this] call spo_fnc_missionSettingsDialog";
		};
		class enemyFactionList: spo_RscListBox
		{
			idc = 2101;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.4610 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.1500 * safezoneH";
			onLBSelChanged = "['select', _this] call spo_fnc_missionSettingsDialog";
		};
		class vehicleFactionLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.6210 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "ENEMY VEHICLES FROM FACTION";
		};
		class vehicleFactionSearch: spo_RscEdit
		{
			idc = 2112;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.6450 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0260 * safezoneH";
			tooltip = "Type to filter by name or category";
			onKeyUp = "['filter', _this] call spo_fnc_missionSettingsDialog";
		};
		class vehicleFactionList: spo_RscListBox
		{
			idc = 2102;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.6750 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.1450 * safezoneH";
			onLBSelChanged = "['select', _this] call spo_fnc_missionSettingsDialog";
		};
		class scanText: spo_RscText
		{
			idc = 1003;
			x = "0.1600 * safezoneW + safezoneX";
			y = "0.6990 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0300 * safezoneH";
			style = 2;
			text = "Reading vehicle configs...";
		};
		class scanBar: spo_RscProgress
		{
			idc = 1004;
			x = "0.1800 * safezoneW + safezoneX";
			y = "0.7340 * safezoneH + safezoneY";
			w = "0.1700 * safezoneW";
			h = "0.0120 * safezoneH";
		};
		class previewLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.1930 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "LOADOUT PREVIEW";
		};
		class previewRole: spo_RscCombo
		{
			idc = 2007;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.2170 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0260 * safezoneH";
			onLBSelChanged = "['role', _this] call spo_fnc_missionSettingsDialog";
		};
		class previewBlu: spo_RscPicture
		{
			idc = 1200;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.2560 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.3400 * safezoneH";
			text = "";
		};
		class previewOp: spo_RscPicture
		{
			idc = 1201;
			x = "0.4875 * safezoneW + safezoneX";
			y = "0.2560 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.3400 * safezoneH";
			text = "";
		};
		class previewBluSide: spo_RscLabel
		{
			idc = -1;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.6000 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.0220 * safezoneH";
			style = 2;
			text = "FRIENDLY";
			colorText[] = SPO_COL_BLU;
		};
		class previewOpSide: spo_RscLabel
		{
			idc = -1;
			x = "0.4875 * safezoneW + safezoneX";
			y = "0.6000 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.0220 * safezoneH";
			style = 2;
			text = "ENEMY";
			colorText[] = SPO_COL_OP;
		};
		class previewBluName: spo_RscSmall
		{
			idc = 1210;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.6220 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.0220 * safezoneH";
			style = 2;
			text = "";
		};
		class previewOpName: spo_RscSmall
		{
			idc = 1211;
			x = "0.4875 * safezoneW + safezoneX";
			y = "0.6220 * safezoneH + safezoneY";
			w = "0.1025 * safezoneW";
			h = "0.0220 * safezoneH";
			style = 2;
			text = "";
		};
		class vehicleTypesLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.6640 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "ENEMY VEHICLE TYPES";
		};
		class vehicleCarsBox: spo_RscCheckBox
		{
			idc = 2201;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.6900 * safezoneH + safezoneY";
			w = "0.0140 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class vehicleCarsText: spo_RscText
		{
			idc = -1;
			x = "0.3960 * safezoneW + safezoneX";
			y = "0.6900 * safezoneH + safezoneY";
			w = "0.0870 * safezoneW";
			h = "0.0260 * safezoneH";
			text = "Cars and trucks";
		};
		class vehicleApcsBox: spo_RscCheckBox
		{
			idc = 2202;
			x = "0.4850 * safezoneW + safezoneX";
			y = "0.6900 * safezoneH + safezoneY";
			w = "0.0140 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class vehicleApcsText: spo_RscText
		{
			idc = -1;
			x = "0.5010 * safezoneW + safezoneX";
			y = "0.6900 * safezoneH + safezoneY";
			w = "0.0870 * safezoneW";
			h = "0.0260 * safezoneH";
			text = "APCs and IFVs";
		};
		class vehicleTanksBox: spo_RscCheckBox
		{
			idc = 2203;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.7220 * safezoneH + safezoneY";
			w = "0.0140 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class vehicleTanksText: spo_RscText
		{
			idc = -1;
			x = "0.3960 * safezoneW + safezoneX";
			y = "0.7220 * safezoneH + safezoneY";
			w = "0.0870 * safezoneW";
			h = "0.0260 * safezoneH";
			text = "Tanks and tracked AA";
		};
		class vehicleHelisBox: spo_RscCheckBox
		{
			idc = 2204;
			x = "0.4850 * safezoneW + safezoneX";
			y = "0.7220 * safezoneH + safezoneY";
			w = "0.0140 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class vehicleHelisText: spo_RscText
		{
			idc = -1;
			x = "0.5010 * safezoneW + safezoneX";
			y = "0.7220 * safezoneH + safezoneY";
			w = "0.0870 * safezoneW";
			h = "0.0260 * safezoneH";
			text = "Armed helicopters";
		};
		class vehicleTypesHint: spo_RscSmall
		{
			idc = -1;
			x = "0.3800 * safezoneW + safezoneX";
			y = "0.7540 * safezoneH + safezoneY";
			w = "0.2100 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "Unticked types never spawn.";
		};
		class mapLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.1930 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "OBJECTIVE - CLICK THE MAP TO PLACE IT";
		};
		class aoMAP: RscMapControl
		{
			idc = 1801;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.2170 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.2500 * safezoneH";
			onMouseButtonClick = "['mapClick', _this] call spo_fnc_missionSettingsDialog";
		};
		class missionLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.4770 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "MISSION TYPE";
		};
		class missionCombo: spo_RscCombo
		{
			idc = 2004;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.5010 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class ratioLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.5370 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "ENEMY STRENGTH (AI PER PLAYER)";
		};
		class ratioSlider: spo_RscSlider
		{
			idc = 1900;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.5610 * safezoneH + safezoneY";
			w = "0.1600 * safezoneW";
			h = "0.0260 * safezoneH";
			onSliderPosChanged = "['ratio', _this] call spo_fnc_missionSettingsDialog";
		};
		class ratioValue: spo_RscText
		{
			idc = 1901;
			x = "0.7620 * safezoneW + safezoneX";
			y = "0.5610 * safezoneH + safezoneY";
			w = "0.0780 * safezoneW";
			h = "0.0260 * safezoneH";
			style = 1;
			text = "";
		};
		class timeLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.5970 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "TIME OF DAY";
		};
		class timeCombo: spo_RscCombo
		{
			idc = 2005;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.6210 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class weatherLabel: spo_RscLabel
		{
			idc = -1;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.6570 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0220 * safezoneH";
			text = "WEATHER";
		};
		class weatherCombo: spo_RscCombo
		{
			idc = 2006;
			x = "0.6000 * safezoneW + safezoneX";
			y = "0.6810 * safezoneH + safezoneY";
			w = "0.2400 * safezoneW";
			h = "0.0260 * safezoneH";
		};
		class footerHint: spo_RscSmall
		{
			idc = -1;
			x = "0.1620 * safezoneW + safezoneX";
			y = "0.8440 * safezoneH + safezoneY";
			w = "0.4000 * safezoneW";
			h = "0.0250 * safezoneH";
			text = "Esc closes without changes. Settings are locked once the mission starts.";
		};
		class cancelButton: spo_RscButton
		{
			idc = 1601;
			x = "0.6450 * safezoneW + safezoneX";
			y = "0.8400 * safezoneH + safezoneY";
			w = "0.0850 * safezoneW";
			h = "0.0320 * safezoneH";
			text = "CANCEL";
			onButtonClick = "closeDialog 2";
		};
		class goButton: spo_RscButtonAccent
		{
			idc = 1600;
			x = "0.7400 * safezoneW + safezoneX";
			y = "0.8400 * safezoneH + safezoneY";
			w = "0.1000 * safezoneW";
			h = "0.0320 * safezoneH";
			text = "LAUNCH";
			onButtonClick = "['done', _this] call spo_fnc_missionSettingsDialog";
		};
	};
};
