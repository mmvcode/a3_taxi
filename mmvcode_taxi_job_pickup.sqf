// Center of the map
private _middle = worldSize/2; 
private _mapCentre = [_middle,_middle,0];

// Group for the spawned AI
private _group = createGroup civilian;	

// Keep the AI from attacking
_group enableAttack false;

// Find a random position next or on a road 11km radius
_road = getPos ((_mapCentre nearRoads 11000) call BIS_fnc_selectRandom); 
_position = [_road, 0, 5, 5, 0, 99999, 0] call BIS_fnc_findSafePos; 

// Random value to be used for each spawned object
_random = round (random 10500);

// Create the AI customer
_name = format ["Customer_%1", _random];
"C_man_polo_1_F" createUnit [_position, _group ,format["%1 = this;", _name], 0.6, "corporal"];
_customer = (call compile _name);
_customer setVehicleVarName _name;

// Prevents the AI to move away from the location
doStop _customer;
_customer setPos _position;

// Event Handler 
_customer addEventHandler ["Init", {
	waitUntil {
		if(_customer distance player < 2) then {
			_veh  = vehicle player;
			this moveInAny _veh;
		} 
	}
}];

// Creates the maker for the customer's position
_customerMarkerText = format ['Pick up customer %1', _name];
_customerMarker = createMarkerLocal [_name, getPos _customer];

// Use the Tasks module to mark the position
private _pick_up_task = player createSimpleTask [_customerMarkerText];
_pick_up_task setSimpleTaskDescription ["Pick up the customer from the marked location", _customerMarkerText, ""];
_pick_up_task setTaskState "Assigned";
_pick_up_task setSimpleTaskDestination (getMarkerPos _customerMarker);

player setCurrentTask _pick_up_task;
player setPos _position;
true