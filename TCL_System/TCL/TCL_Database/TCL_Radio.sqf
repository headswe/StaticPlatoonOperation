// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Radio Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_Radio") then
	{
		TCL_Radio = [
		
			// 0 - 2 ( Radio )
			True,
			30,
			[3000, 5000, 7000, 10000, 13000]
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Radio.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Radio.sqf";
			};
		};
	};
};