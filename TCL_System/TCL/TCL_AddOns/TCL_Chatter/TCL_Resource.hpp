// Vehicle Macro
#define _getVehicle(type) (_vehicle isKindOf type)
#define _isMan(object) (object == vehicle object)

// Side Macro
#define _getSide(object) (side object in _getArray(TCL_Core,1) )

// Array Macro
#define _getDebug(index) (TCL_Debug select index)
#define _getLocal(index) (TCL_Local select index)
#define _getGlobal(index) (TCL_Global select index)
#define _getArray(array,index) (array select index)
#define _spawn(array,index) spawn (array select index)
#define _call(array,index) call (array select index)
#define _setIn(array,index,value) [array,index,value] call TCL_Array_F
#define _isIn(group,array,index) (group in (array select index) )
#define _setOut(array,index,value) array set [index, (array select index) - [value] ]

// Unit Macro
#define _isLeader(object) (object == leader object)
#define _getUnit(index) units _group select (count units _group - index)
#define _getUnits(group) { (alive _x) } count (units group)

// Number Macro
#define _getRandom(value) (floor (random 100) < value)
#define _getTime(value) (time + (value) )

// Enemy and Friend Macro
#define _getKnows(object) knowsAbout vehicle object
#define _isKnown(object) ( (alive object) && (_group _getKnows(object) > 0) )

#define _getEnemy(object) ( { ( (alive _x) && _isLeader(_x) && (side _x getFriend side object < 0.6) ) } count (units _group) > 0)
#define _getFriend(group) ( { ( (alive _x) && _isLeader(_x) && (side _x getFriend side leader group > 0.6) ) } count (units _group) > 0)

#define _isEnemy(object) (_isKnown(object) && _getEnemy(object) )
#define _isFriend(object) (_isKnown(object) && _getFriend(object) )

// Vehicle Macro
#define _unAssignVehicle(object) unAssignVehicle object; [object] orderGetIn False

// Variable Macro
#define _getVariable(object,string) [object,string] call TCL_Get_Variable_F

// uiNameSpace
#define _callUI(string,index) call (uiNameSpace getVariable string select index)
#define _spawnUI(string,index) spawn (uiNameSpace getVariable string select index)