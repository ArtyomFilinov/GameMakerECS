// You can add more events for systems by simply adding an event and writing call_systems_events() in it.

systems = [new system_input(), new system_movement(), new system_moving()];
systems_num = array_length(systems);

call_systems_events = function() {
	var event = event_number;
	for(var i = 0; i < systems_num; i ++) {
		var sys = systems[i];
		if (sys.event_exists(event)) {
			with(all) sys.call_event(id, event);
		}
	}
}

call_systems_events();