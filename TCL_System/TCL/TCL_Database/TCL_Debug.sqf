// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Debug Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (isNil "TCL_Debug") then
{
	TCL_Debug = [
	
		// 0 ( System Debug )
		False,
		
		// 1 - 3 ( Marker Debug )
		False,
		False,
		False,
		
		// 4 ( Cursor )
		False,
		
		// 5 ( Mission Debug )
		False,
		
		// 6 ( Development Debug )
		False
	];
	
	if (TCL_Server) then
	{
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Debug.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Debug.sqf";
			};
		};
	};
};