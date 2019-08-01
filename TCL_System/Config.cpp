// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link - ( TypeX ) - System Config
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

#define _ARMA_

class CfgPatches
{
	class TCL_System
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.82;
		requiredAddons[] = {"A3_Data_F","A3_Characters_F"};
		versionDesc = "Tactical Combat Link - ( TypeX )";
		version = "1.0.31";
	};
};

class CfgMods
{
	class TCL_Mods
	{
		dir = "@TCL";
		name = "Tactical Combat Link - ( TypeX )";
		author = "=\SNKMAN/=";
		action = "https://forums.bohemia.net/forums/topic/221659-tactical-combat-link-typex/";
		picture = "A3\Ui_f\data\Logos\arma3_expansion_alpha_ca";
		tooltip = "Tactical Combat Link";
		overview = "Tactical Combat Link - ( TypeX ) is a highly dynamic A.I. and F.X. improvement and enhancement modification for ARMA 3.";
	};
};

class TCL_Path
{
	// ///////////// PBO ////////////////
	TCL_Root = "\TCL_System\";
	// /////////////////////////////////////

	// ///////////// Script ////////////////
	// TCL_Root = "\@TCL\AddOns\TCL_System\";
	// ///////////////////////////////////////
};

#define TCL_EH_System "if (isNil 'TCL_Path') then {TCL_Path = getText (configFile >> 'TCL_Path' >> 'TCL_Root'); call compile preProcessFileLineNumbers (TCL_Path+'TCL_Preprocess.sqf') }";

class CfgVehicles
{
	class Man;
	class Land;
	
	class CAManBase : Man
	{
		class EventHandlers
		{
			class TCL_EH_Init
			{
				init = TCL_EH_System
			};
		};
	};
};

class RscText;

class RscStandardDisplay;

class RscDisplayMain : RscStandardDisplay
{
	class controls
	{
		class TCL_System_RscDisplayMain : RscText
		{
			style = 0x01 + 0x100;

			sizeEx = 0.05;

			x = "(SafeZoneH + SafeZoneX) - (1 - 0.45)";
			y = "(SafeZoneH + SafeZoneY) - (1 - 0.83)";

			w = 0.5;
			h = 0.05;

			text = "Tactical Combat Link - TypeX";
		};

		class TCL_Version_RscDisplayMain : TCL_System_RscDisplayMain
		{
			sizeEx = 0.03;

			colortext[] = {1.0, 0.0, 0.0, 1.0};

			x = "(SafeZoneH + SafeZoneX) - (1 - 0.45)";
			y = "(SafeZoneH + SafeZoneY) - (1 - 0.88)";

			text = "Version: 1.0.31";
		};
	};
};

class CfgAddOns
{
	class PreloadBanks {};
	
	class PreloadAddOns
	{
		class TCL_System
		{
			list[] = {"TCL_System"};
		};
	};
};