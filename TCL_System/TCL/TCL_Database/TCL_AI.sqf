// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// A.I. Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_AI") then
	{
		TCL_AI = [
		
			// 0 - 2 ( Reinforcement )
			1,
			0.15,
			3,
			
			// 3 - 6 ( Additional )
			False,
			3,
			700,
			True,
			
			// 7 - 8 ( Disable )
			False,
			False,
			
			// 9 ( Regroup )
			True,
			
			// 10 ( Timeout )
			170,
			
			// 11 ( Synchronize )
			False
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_AI.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_AI.sqf";
			};
		};
	};
};