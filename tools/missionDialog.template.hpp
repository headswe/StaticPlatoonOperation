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
//@CONTROLS@
};
