/*  ////////////////////////////////////////////////////////////////////////////////
\   \ Tactical Combat Link
 \   \------------------------------------------------------------------------------
  \   \ Preprocess
   \   \----------------------------------------------------------------------------
   /   / By =\SNKMAN/=
  /   /-----------------------------------------------------------------------------
*/   ///////////////////////////////////////////////////////////////////////////////

if (is3DEN) exitWith {};

if (isNil "TCL_Preprocess") then
{
	TCL_Server = False;
	
	TCL_Database = False;
	
	TCL_Preprocess = True;
	
	TCL_Initialize = False;
	
	if (isServer) then
	{
		TCL_Server = True;
	};
	
	TCL_Headless = False;
	
	TCL_Dedicated = False;
	
	TCL_Multiplayer = False;
	
	if (isMultiplayer) then
	{
		TCL_Interface = False;
		
		TCL_Multiplayer = True;
		
		if (isDedicated) then
		{
			TCL_Dedicated = True;
		};
		
		if (hasInterface) then
		{
			TCL_Interface = True;
		};
		
		if ( (TCL_Server) || (TCL_Interface) ) exitWith {};
		
		TCL_Headless = True;
		
		TCL_Dedicated = True;
	};
	
	TCL_FilePatching = False;
	
	if (isFilePatchingEnabled) then
	{
		TCL_FilePatching = True;
	};
	
	execFSM (TCL_Path+"TCL_Initialize.fsm");
};