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
params [["_spawnPos",[0,0,0],[[]]], ["_type",0,[0]], ["_count",1,[0]], ["_side", GVAR(enemySide)], ["_uncache",false]];
_spawnPos set [2, 0];

private _grp = createGroup _side;
_grp allowfleeing 0;
private _driverArray = [];
private _vehArray = [];
for "_j" from 0 to (_count - 1) do {
    private _pos = _spawnPos;
    _pos set [2, 0];
    call {
        if (_type isEqualTo 0) exitWith {
            private _unit = _grp createUnit [GETCLASS(_side,_type), _pos, [], 0, "NONE"];
            _unit allowDamage false;
        };
        private _veh = if (_type isEqualTo 1) then {
            private _type = GETCLASS(_side,_type);
            createVehicle [_type, _pos, [], 0, "NONE"];
        } else {
            private _type = GETCLASS(_side,_type);
            createVehicle [_type, _pos, [], 0, "FLY"];

        };
        _vehArray pushBack _veh;
        _veh allowDamage false;
        private _unit = _grp createUnit [GETCLASS(_side,0),_pos, [], 0, "NONE"];
        _unit moveInDriver _veh;
        _unit allowDamage false;
        _driverArray pushBack _unit;

        if !((_veh emptyPositions "gunner") isEqualTo 0) then {
            for "_i" from 1 to (_veh emptyPositions "gunner") do {
                _unit = _grp createUnit [GETCLASS(_side,0),_pos, [], 0, "NONE"];
                _unit moveInGunner _veh;
                _unit allowDamage false;
            };
        };
        if !((_veh emptyPositions "commander") isEqualTo 0) then {
            for "_i" from 1 to (_veh emptyPositions "commander") do {
                _unit = _grp createUnit [GETCLASS(_side,0), _pos, [], 0, "NONE"];
                _unit moveInCommander _veh;
                _unit allowDamage false;
            };
        };
    };
};

#ifdef ISDEV
[{
    (_this select 0) params ["_obj"];
    [getPos _obj, "mil_triangle", "ColorEAST", getDir _obj] call FUNC(createMarker);
}, 10, [leader _grp]] call CFUNC(addPerFrameHandler);
#endif
{
    _x setRank (selectRandom ["PRIVATE", "CORPORAL", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR", "COLONEL"]);
    nil
} count (units _grp);
[{
    params ["_grp","_vehArray"];
    {
        _x allowDamage true;
        nil
    } count (units _grp);
    {
        _x allowDamage true;
        nil
    } count _vehArray;
}, 10, [_grp, _vehArray]] call CFUNC(wait);
if (_uncache) then {NOCACHE(_grp);};
if (_type isEqualTo 0) exitWith {_grp};

_driverArray
