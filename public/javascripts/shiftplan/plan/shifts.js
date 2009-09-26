function Shifts(element) {
	Resource.call(this, Shifts, element);
};

$.extend(Shifts, Resource)

$.extend(Shifts, {
	selector: '.shifts',
	on_drop: function(event, ui) {
		switch(true) {
			case ui.draggable.parent().hasClass('workplace'):
				Shifts.on_workplace_drop.call(this, event, ui);
				break;
			default:
				Plan.on_element_remove(event, ui);
				break;
		}
	},
	on_workplace_drop: function(event, ui) {
		var shifts = $(this).shifts();
		var workplace = ui.draggable.workplace();

		// extract to shifts.rasterize(left, width)
		var left = parseInt(ui.offset.left - this.offsetLeft - 1);
		left = left - (left % Plan.slot_width);
		var width = Plan.slot_width * Plan.default_slot_count;
		if(left + width > this.offsetWidth) {
			width = this.offsetWidth - left - 1;
		}

		var shift = Shift.build(workplace);
		shifts.append_shift(shift, left, width);
		shift.save();
		shifts.reset_drop_zone();
	},
	on_workplace_over: function(event, ui) {
		if(ui.draggable.parent().hasClass('workplace')) {
			$(this).shifts().expand_drop_zone();
		}
	},
	on_workplace_out: function(event, ui) {
		if(ui.draggable.parent().hasClass('workplace')) {
			$(this).shifts().reset_drop_zone();
		}
	},
});

Shifts.prototype = $.extend(new Resource, {
	append_shift: function(shift, left, width) {
		shift.element.css({ left: left });
		// shift.expand_animated(width);
		shift.width(width);
		shift.update_data_from_dimension();
		this.element.append(shift.element);
	},
	expand_drop_zone: function() {
		Util.fix_droppable_proportions(30);
		this.element.css('padding-bottom', '30px');
	},
	reset_drop_zone: function() {
		Util.fix_droppable_proportions(-30);
		this.element.css('padding-bottom', '0px');
	},
	bind_events: function() {
		this.element.droppable({
			accept: "#workplaces a div, #plan .requirement, #plan .assignment",
			tolerance: 'touch',
			greedy: true,
			drop: Shifts.on_workplace_drop,
			drop: Shifts.on_drop,
			over: Shifts.on_workplace_over,
			out:  Shifts.on_workplace_out
		});
	},
});