private ["_taxiCab", "_me", "_taxiCabName", "_middle", "_mapCentre", "_group", "_road", "_position", "_random", "_name", "_customer", "_customerMarkerText", "_customerMarker", "_pickUpTask", "_taskDesc", "_trg"];

_me = player;
_taxiCabName = format ["taxi_%1", _me];
_taxiCab = _this select 0;
_taxiCab setName _taxiCabName;

// Center of the map
_middle = worldSize/2; 
_mapCentre = [_middle,_middle,0];

player moveInDriver _taxiCab;
// Group for the spawned AI
_group = createGroup civilian;	

// Keep the AI from attacking
_group enableAttack false;

// Find a random position next or on a road 1km radius
// It also returns airport runways, so those need to be excluded
_road = getPos ((_mapCentre nearRoads 1000) call BIS_fnc_selectRandom); 
_position = [_road, 0, 5, 5, 0, 99999, 0] call BIS_fnc_findSafePos; 

// Random value to be used for each spawned object
_random = round (random 10500);

// Create the AI customer
_name = format ["Customer_%1", _random];
"C_man_polo_5_F_afro" createUnit [_position, _group ,format["%1 = this;", _name], 0.6, "corporal"];
_customer = (call compile _name);
_customer setVehicleVarName _name;

// Prevents the AI to move away from the location
doStop _customer;
_customer setPos _position;

// Creates the maker for the customer's position
_customerMarkerText = format ['Pick up customer %1', _name];
_customerMarker = createMarkerLocal [_name, getPos _customer];

// Use the Tasks module to mark the position
_pickUpTask = player createSimpleTask [_customerMarkerText];
_taskDesc = format ["Pick up the customer from the marked location (%1)",_position];
_pickUpTask setSimpleTaskDescription [_taskDesc, _customerMarkerText, ""];
_pickUpTask setTaskState "Assigned";
_pickUpTask setSimpleTaskDestination (getMarkerPos _customerMarker);

// Assign the task to player
player setCurrentTask _pickUpTask;
["TaskAssigned",[_taskDesc]] call bis_fnc_showNotification;

// Trigger for the pick up zone
_trg = createTrigger ["EmptyDetector", getPos _customer];
_trg setTriggerArea [5, 5, 0, false];
_trg setTriggerActivation ["CIV", "PRESENT", false];
_trg setTriggerStatements ["(vehicle player) in thisList",  "hint 'civilian near'", "hint 'no civilian near'"];

// Wait until the player enters the trigger
waitUntil {triggerActivated _trg};

// Get customer in the car
_customer moveInAny _taxiCab;

// Complete the task and notify player
_pickUpTask setTaskState "Succeeded";
["TaskSucceeded",["Pick up the customer."]] call bis_fnc_showNotification;

// Next step, go to destination
[player, _taxiCab, _customer, _pickUpTask] spawn mmvcode_fnc_taxi_drive_to_location;