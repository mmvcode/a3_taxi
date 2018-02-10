private["_max", "_middle", "_mapCentre", "_count", "_roads", "_road", "_position", "_vehicle", "_hitpoints"]; 
 
_max = 3; 
_middle = worldSize/2; 
_mapCentre = [_middle,_middle,0];
_count = 0; 
_group = createGroup civilian;	
_group enableAttack false;
for "_i" from 1 to _max do { 
    _road = getPos ((_mapCentre nearRoads 11000) call BIS_fnc_selectRandom); 
    _position = [_road, 0, 5, 5, 0, 99999, 0] call BIS_fnc_findSafePos; 
	_customer = _group createUnit ["C_man_polo_1_F", _position, [], 0, 'CAN_COLLIDE'];
	_customerMarker = createMarker ["Customer", getPos _customer];
	_customerMarker setMarkerShape "RECTANGLE";
	_customerMarker setMarkerSize [100,100];
	doStop _customer;
	player setPos _position;
    _customer setPos _position;
    _count = _count + 1; 
}; 
  
//hint format ["Vehicles Spawned: %1", _count]; 
true