// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// I.Q. Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_IQ") then
	{
		TCL_IQ = [
		
			// 0 ( Knowledge )
			1,
			
			// 1 ( Distance )
			100,
			
			// 2 ( KnowsAbout )
			3
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_IQ.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_IQ.sqf";
			};
		};
	};
};