
_weather = (floor (random [0, 1, 9])) min 8;
_setFog = true;
_setWind = true;

_MissionOvercast = 0;
_MissionRain = 0;
_MissionRainbow = 0;
_MissionLightnings = 0;
_MissionWindStr = 0.01;
_MissionWindGusts = 0.01;
_MissionWaves = 0;
_MissionHumidity = 0;
_MissionFogStrength = 0;
_MissionFogDecay = 0;
_MissionFogBase = 0;

// ====================================================================================

// SELECT MISSION WEATHER
// Using the value of _weather, new weather conditions are set.

switch (_weather) do
{
// Clear
	case 0:
	{
		_MissionOvercast = 0;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.01;
		_MissionWindGusts = 0.01;
		_MissionWaves = 0;
		_MissionHumidity = 0;
		_MissionFogStrength = 0;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Cloudy
	case 1:
	{
		_MissionOvercast = 0.25;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.2;
		_MissionWindGusts = 0.2;
		_MissionWaves = 0.3;
		_MissionHumidity = 0.2;
		_MissionFogStrength = 0;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Mostly Cloudy
	case 2:
	{
		_MissionOvercast = 0.55;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.25;
		_MissionWaves = 0.5;
		_MissionHumidity = 0.2;
		_MissionFogStrength = 0;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Overcast
	case 3:
	{
		_MissionOvercast = 1;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.25;
		_MissionWaves = 0.5;
		_MissionHumidity = 0.2;
		_MissionFogStrength = 0;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Foggy
	case 4:
	{
		_MissionOvercast = 0.9;
		_MissionRain = 0;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.1;
		_MissionWindGusts = 0.1;
		_MissionWaves = 0.25;
		_MissionHumidity = 0.2;
		_MissionFogStrength = 0.5;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Showers
	case 5:
	{
		_MissionOvercast = 0.55;
		_MissionRain = 0.1;
		_MissionRainbow = 0.6;
		_MissionLightnings = 0;
		_MissionWindStr = 0.2;
		_MissionWindGusts = 0.2;
		_MissionWaves = 0.5;
		_MissionHumidity = 0.2;
		_MissionFogStrength = 0.03;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Light Rain
	case 6:
	{
		_MissionOvercast = 1;
		_MissionRain = 0.2;
		_MissionRainbow = 0.4;
		_MissionLightnings = 0;
		_MissionWindStr = 0.25;
		_MissionWindGusts = 0.25;
		_MissionWaves = 0.5;
		_MissionHumidity = 0.9;
		_MissionFogStrength = 0.07;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Heavy Rain
	case 7:
	{
		_MissionOvercast = 1;
		_MissionRain = 0.8;
		_MissionRainbow = 0;
		_MissionLightnings = 0;
		_MissionWindStr = 0.4;
		_MissionWindGusts = 0.4;
		_MissionWaves = 0.8;
		_MissionHumidity = 0.9;
		_MissionFogStrength = 0.15;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
// Storm
	case 8:
	{
		_MissionOvercast = 1;
		_MissionRain = 1;
		_MissionRainbow = 0;
		_MissionLightnings = 1;
		_MissionWindStr = 0.75;
		_MissionWindGusts = 1;
		_MissionWaves = 1;
		_MissionHumidity = 1;
		_MissionFogStrength = 0.3;
		_MissionFogDecay = 0;
		_MissionFogBase = 0;
	};
};

// ====================================================================================

// SET MISSION WEATHER
// Use new values to set
// mission conditions on server and all clients (including JIP clients).


0 setOvercast  _MissionOvercast;
0 setRain _MissionRain;
0 setRainbow _MissionRainbow;
0 setLightnings _MissionLightnings;
if (_setWind) then {
	0 setWindStr  _MissionWindStr;
	0 setWindForce _MissionWindGusts;
	0 setWaves _MissionWaves;
};
if (_setFog) then {
	0 setFog [_MissionFogStrength,_MissionFogDecay,_MissionFogBase];
};
forceWeatherChange;
