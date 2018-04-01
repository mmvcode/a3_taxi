private ["_player", "_vehicle", "_customer", "_task", "_location", "_building", "_building_pos", "_destination", "_customerName", "_customerMarkerText", "_buildingPos", "_customerMarker", "_dropOffTask", "_trg"];

_player = _this select 0;
_vehicle = _this select 1;
_customer = _this select 2;
_task = _this select 3;

// Current position
_location = position player;

// Find a random position next or on a road 5km radius
_building = nearestObjects [player, ["house"], 5000] call BIS_fnc_selectRandom;
_buildingPos = getPos _building;
_destination = [_buildingPos, 2000, 5000, 1, 0, 0.7, 0] call BIS_fnc_findSafePos; 

// Creates the maker for the customer's destination
_customerName = name _customer;
_customerMarkerText = format ['Drop off %1.', _customerName];
_customerMarker = createMarkerLocal [_customerName, _buildingPos];

// Use the Tasks module to mark the position
_taskDesc = format ["Drop the customer to the marked location (%1)",_buildingPos];
_dropOffTask = player createSimpleTask [_customerMarkerText];
_dropOffTask setSimpleTaskDescription [_taskDesc, _customerMarkerText, ""];
_dropOffTask setTaskState "Assigned";
_dropOffTask setSimpleTaskDestination (getMarkerPos _customerMarker);

// Assign the task and show a notification
player setCurrentTask _dropOffTask;
["TaskAssigned",[_taskDesc]] call bis_fnc_showNotification;

// The trigger that checks for arrival
_trg = createTrigger ["EmptyDetector", _buildingPos];
_trg setTriggerArea [15, 15, 0, false];
_trg setTriggerActivation ["CIV", "PRESENT", false];
_trg setTriggerStatements ["(vehicle player) in thisList",  "", ""];

// Wait until the vehicle enters the trigger
waitUntil {triggerActivated _trg};

// Disembark the customer
unassignVehicle _customer;

// Finish the task
_dropOffTask setTaskState "Succeeded.";
["TaskSucceeded",["Fare completed."]] call bis_fnc_showNotification;

// Delete customer
sleep 2;
deletevehicle _customer;
