private ["_player", "_vehicle", "_customer", "_task", "_location", "_building", "_destination", "_customer_name", "_customerMarkerText", "_building_pos", "_customerMarker", "_drop_off_task"];

_player = _this select 0;
_vehicle = _this select 1;
_customer = _this select 2;
_task = _this select 3;

// Current position
_location = position player;

// Find a random position next or on a road 5km radius
_building = nearestObjects [player, ["house"], 5000] call BIS_fnc_selectRandom;
_building_pos = getPos _building;
_destination = [_building_pos, 2000, 5000, 1, 0, 0.7, 0] call BIS_fnc_findSafePos; 

// Creates the maker for the customer's destination
_customer_name = name _customer;
_customerMarkerText = format ['Drop off %1.', _customer_name];
_customerMarker = createMarkerLocal [_customer_name, _building_pos];

// Use the Tasks module to mark the position
_task_desc = format ["Drop the customer to the marked location (%1)",_building_pos];
_drop_off_task = player createSimpleTask [_customerMarkerText];
_drop_off_task setSimpleTaskDescription [_task_desc, _customerMarkerText, ""];
_drop_off_task setTaskState "Assigned";
_drop_off_task setSimpleTaskDestination (getMarkerPos _customerMarker);

// Assign the task and show a notification
player setCurrentTask _drop_off_task;
["TaskAssigned",[_task_desc]] call bis_fnc_showNotification;

// The trigger that checks for arrival
_trg = createTrigger ["EmptyDetector", _building_pos];
_trg setTriggerArea [15, 15, 0, false];
_trg setTriggerActivation ["CIV", "PRESENT", false];
_trg setTriggerStatements ["(vehicle player) in thisList",  "", ""];

// Wait until the vehicle enters the trigger
waitUntil {triggerActivated _trg};

// Disembark the customer
unassignVehicle _customer;

// Finish the task
_drop_off_task setTaskState "Succeeded.";
["TaskSucceeded",["Fare completed."]] call bis_fnc_showNotification;

// Delete customer
sleep 2;
deletevehicle _customer;
