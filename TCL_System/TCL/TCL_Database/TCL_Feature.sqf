// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Feature Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_Feature") then
	{
		TCL_Feature = [
		
			// 0 ( Watch )
			True,
			50,
			
			// 2 ( Garrison )
			True,
			
			// 3 - 6 ( Smoke )
			True,
			50,
			True,
			75,
			
			// 7 ( Flare )
			True,
			50,
			
			// 9 ( Artillery )
			True,
			15,
			
			// 11 ( House Search )
			True,
			50,
			
			// 13 ( Static Weapon )
			True,
			50,
			
			// 15 - 18 ( Take Cover )
			True,
			50,
			30,
			50,
			
			// 19 - 21 ( Flanking )
			True,
			50,
			50,
			
			// 22 - 26 ( Advancing )
			True,
			15,
			50,
			300,
			700,
			
			// 27 - 29 ( Suppressed )
			True,
			0.90,
			5,
			
			// 30 - 31 ( Heal )
			True,
			50,
			
			// 32 - 33 ( Rearm )
			True,
			50,
			
			// 34 - 35 ( Surrender )
			True,
			5
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Feature.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Feature.sqf";
			};
		};
	};
};