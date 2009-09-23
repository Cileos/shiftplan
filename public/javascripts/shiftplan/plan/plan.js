var Plan = {
	slot_width: 18,
	slots_per_hour: 4,
	default_slot_count: 12,
	init: function() {
    this.bind_events();
	},
	bind_events: function() {
		$("body").droppable({
			accept: ".shift, .requirement, .assignment",
			drop: Plan.on_element_remove,
		});
	},
	start: function() {
		return $("#plan").attr("data-start");
	},
	minutes_per_slot: function() {
		return parseInt(60 / Plan.slots_per_hour);
	},
	pixels_per_hour: function() {
		return Plan.slot_width * Plan.slots_per_hour;
	},
	pixels_per_minute: function() {
		return Plan.pixels_per_hour() / 60;
	},
	on_element_remove: function(event, ui) {
		ui.draggable.resource().remove();
	}
}