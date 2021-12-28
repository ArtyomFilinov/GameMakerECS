#region Components. 

// Base component. 
function ecs_component() constructor {
	name = "";
}

function add_component(_component) {
	var component_name = _component.name;
	components[? component_name] = _component;
	
	asset_add_tags(object_index, component_name, asset_object);
}

function has_components(_entity, _components) {
	return asset_has_tags(_entity.object_index, _components, asset_object);
}

function get_component(_entity, _name) {
	return _entity.components[? _name];
}

function component_moving(_spd) : ecs_component() constructor {
	name = "moving";
	
	hsp = 0;
	vsp = 0;
	spd = _spd;
}

function component_input() : ecs_component() constructor {
	name = "input";
	
	key_left = false;
	key_right = false;
	key_up = false;
	key_down = false;
	
	axis_h = 0;
	axis_v = 0;
}

#endregion

#region Systems. 

// Base system.  
function ecs_system() constructor {
	necessary_components = []; // An array (or variable) of components necessary for the operation of the system.
	events = ds_map_create(); // Map is needed to support multiple events with one system. 
	
	add_components = function(_names) {
		necessary_components = _names;
	}
	
	call_event = function(_entity, _event) {
		if (has_components(_entity, necessary_components)) events[? _event](_entity);
	}
	
	add_event = function(_event, _code) {
		events[? _event] = _code;
	}
	
	event_exists = function(_event) {
		return ds_map_exists(events, _event);
	}
	
	clean = function() {
		ds_map_destroy(events);
	}
}

function system_input() : ecs_system() constructor {
	add_components("input");
	
	add_event(ev_step_begin, function(_entity) {
		var c_input;
		c_input = get_component(_entity, "input");
		
		var left, right, up, down;
		left = keyboard_check(ord("A"));
		right = keyboard_check(ord("D"));
		up = keyboard_check(ord("W"));
		down = keyboard_check(ord("S"));
		
		c_input.key_left = left;
		c_input.key_right = right;
		c_input.key_up = up;
		c_input.key_down = down;
		
		c_input.axis_h = (right - left);
		c_input.axis_v = (down - up);
	});
}

function system_movement() : ecs_system() constructor {
	add_components(["input", "moving"]);
	
	add_event(ev_step_normal, function(_entity) {
		var c_input, c_moving;
		c_input = get_component(_entity, "input");
		c_moving = get_component(_entity, "moving");
		
		var spd_h, spd_v, spd_f;
		spd_h = c_input.axis_h;
		spd_v = c_input.axis_v;
		spd_f = c_moving.spd;
		
		var len = sqrt(spd_h * spd_h + spd_v * spd_v);
		if (len != 0) {
			spd_h /= len;
			spd_v /= len;
		}
		
		c_moving.hsp = spd_h * spd_f;
		c_moving.vsp = spd_v * spd_f;
	});
}

function system_moving() : ecs_system() constructor {
	add_components("moving");
	
	add_event(ev_step_normal, function(_entity) {
		var c_moving = get_component(_entity, "moving");
		
		var spd_h, spd_v;
		spd_h = c_moving.hsp;
		spd_v = c_moving.vsp;
		
		_entity.x += spd_h;
		_entity.y += spd_v;
	});
}

#endregion








