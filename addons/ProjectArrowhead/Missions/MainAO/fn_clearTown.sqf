#include "macros.hpp"
/*
    Project Arrowhead

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    0: Argument <Type>

    Returns:
    0: Return <Type>
*/

private _locData = call MFUNC(getLocation);
_locData params ["_pos", "_name", "_size", "_location"];
MGVAR(locationData) = _locData select [0,3];

GVAR(location) = _location;
_size = _size * ([CFGPRAW(MainAOSize), 2] call CFUNC(getSetting));
MGVAR(mainAOSize) = _size;
MGVAR(mainAOPos) = _pos;
private _mrk = createMarker [QGVAR(mainAO), MGVAR(mainAOPos)];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [MGVAR(mainAOSize), MGVAR(mainAOSize)];
_mrk setMarkerBrush "Border";
_mrk setMarkerColor "ColorOPFOR";

publicVariable QMGVAR(locationData);
publicVariable QMGVAR(mainAOPos);
publicVariable QMGVAR(mainAOSize);

QGVAR(spawnClearTownUnits) call CFUNC(localEvent);
