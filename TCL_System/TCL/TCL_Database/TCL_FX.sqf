// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// FX Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (isNil "TCL_FX") then
{
	TCL_FX = [
	
		// 0 ( Bullet )
		True,
		5,
		
		// 2 ( Shell )
		True,
		50,
		
		// 4 ( Church )
		True,
		
		// 5 ( Lighthouse )
		True,
		
		// 6 - 10 ( Radio )
		True,
		3,
		3,
		199,
		210,
		
		// 11 ( Crew )
		True,
		35,
		
		// 13 ( Explosion )
		True
	];
	
	if (TCL_FilePatching) then
	{
		if ("UserConfig\TCL\TCL_FX.sqf" call TCL_Exist_F) then
		{
			call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_FX.sqf";
		};
	};
};