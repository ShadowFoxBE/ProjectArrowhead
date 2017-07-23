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
params ["_grp", "_maxRange", "_houseArray", ["_waypointCount", 5]];
private _minDist = _maxRange * 0.30;
private _waypointsrange = 5;
private _posArray = [];
private _pos1 = getposATL (leader _grp);
private _wpindex = 0;
private _usesHouses = (_houseArray isEqualTo []);

for "_i" from 1 to 50 do {
    if (_usesHouses && {random 1 < 0.35}) then {
        private _house = selectRandom _houseArray;
        private _housePosArray = _house buildingPos -1;
        private _houses = _houses - [_house];
        if (count _housePosArray > 1) then {
            private _pos2 = getPos _house;
            _posArray pushBack _pos2;
            _wpindex = _wpindex + 1;
            private _wp = _grp addWaypoint [_pos2, 0];
            _wp setWaypointType (selectRandom ["MOVE", "LOITER"]);
            _wp waypointAttachObject _house;
            [_grp, _wpindex] setWaypointHousePosition floor(random(count _housePosArray));
            [_grp, _wpindex] setWaypointBehaviour "SAFE";
            [_grp, _wpindex] setWaypointCombatMode "RED";
            [_grp, _wpindex] setWaypointCompletionRadius _waypointsrange;
            [_grp, _wpindex] setWaypointLoiterRadius _waypointsrange;
            [_grp, _wpindex] setWaypointTimeout [2,20,6];
            [_grp, _wpindex] setWaypointStatements ["true", DFUNC(exitPatrol)];
        };
    } else {
        private _dir = random 360;

        private _range = (ceil random _maxRange);
        private _pos2 = [(_pos1 select 0) + (sin _dir) * _range, (_pos1 select 1) + (cos _dir) * _range, 0];
        if !(surfaceIsWater _pos2) then {
            if ({(_pos2 distance _x) < _minDist} count _posArray isEqualTo 0) then {
                _posArray pushBack _pos2;
                _wpindex = _wpindex + 1;
                private _wp = _grp addWaypoint [_pos2, 0];
                _wp setWaypointType (selectRandom ["MOVE", "LOITER"]);
                [_grp, _wpindex] setWaypointBehaviour "SAFE";
                [_grp, _wpindex] setWaypointCombatMode "RED";
                [_grp, _wpindex] setWaypointCompletionRadius _waypointsrange;
                [_grp, _wpindex] setWaypointLoiterRadius _waypointsrange;
                [_grp, _wpindex] setWaypointTimeout [2,20,6];
                [_grp, _wpindex] setWaypointStatements ["true", DFUNC(exitPatrol)];
            };
        };
    };
    if (count _posArray isEqualTo _waypointCount) then {
        [_grp, _wpindex] setWaypointStatements ["true", "(group this) setCurrentWaypoint [group this, 1];" + DFUNC(exitPatrol)];
        breakTo SCRIPTSCOPENAME;
    };
};