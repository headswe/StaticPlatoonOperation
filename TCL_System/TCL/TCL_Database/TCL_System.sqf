// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// System Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (isNil "TCL_System") then
{
	TCL_System = [
	
		// 0 ( Delay )
		0,
		
		// 1 ( A.I. )
		True,
		
		// 2 ( Sides )
		[EAST, WEST, RESISTANCE],
		
		// 3 ( Combat System )
		True,
		
		// 4 ( Get In )
		True,
		
		// 5 ( Skill )
		True,
		
		// 6 ( Skill Divider )
		5,
		
		// 7 ( Spawn )
		True,
		
		// 8 ( Delay )
		0,
		
		// 9 ( F.X. )
		True,
		
		// 10 ( Respawn )
		False
	];
	
	if (TCL_Server) then
	{
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_System.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_System.sqf";
			};
		};
		
		if (TCL_Multiplayer) then
		{
			publicVariable "TCL_System";
		};
	};
};