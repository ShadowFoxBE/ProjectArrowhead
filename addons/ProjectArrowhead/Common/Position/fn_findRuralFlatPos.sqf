#include "macros.hpp"
/*
    Community Lib - CLib

    Author: joko // Jonas

    Description:
    Description

    Parameter(s):
    0: Argument <Type>

    Returns:
    0: Return <Type>
*/

params ["_center", "_range","_dist"];

private _pos = [0,0,0];

for "_s" from 0 to 100 do {
    _pos = [_center,0,_range] call FUNC(selectRandomPos);
    if !([_pos, "SEN_safezone_mrk"] call SEN_fnc_checkInMarker) then {
        if (count (_pos isFlatEmpty [1, 0, 0.3, 30, 0, false, objNull]) != 0 && {count (_pos isFlatEmpty [1, 0, 0.12, _dist min 300, 0, false, objNull]) != 0}) then {
            if (count (nearestObjects [_pos, ["house"], _dist*1.7]) isEqualTo 0) then {
                private _dummypad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE"];
                if !(surfaceIsWater (_dummypad modelToWorld [0,-100,0]) || {surfaceIsWater (_dummypad modelToWorld [0,100,0])} || {surfaceIsWater (_dummypad modelToWorld [100,0,0])} || {surfaceIsWater (_dummypad modelToWorld [-100,0,0])}) then {
                    deleteVehicle _dummypad;
                    breakTo SCRIPTSCOPENAME;
                };

                deleteVehicle _dummypad;
            };
        };
    };
};

if (_pos isEqualTo [0,0,0]) then {LOG("No Position Found");};


_pos
