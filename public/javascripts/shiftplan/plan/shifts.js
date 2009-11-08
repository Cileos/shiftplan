(function() {
  Shifts = function(element) {
  	Resource.call(this, Shifts, element);
  };

  $.extend(Shifts, Resource, {
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
  		var default_shift_length = workplace.default_shift_length();
  		var width = default_shift_length ?
        default_shift_length * Plan.pixels_per_minute() :
        Plan.slot_width * Plan.default_slot_count;
  		if(left + width > this.offsetWidth) {
  			width = this.offsetWidth - left - 1;
  		}

  		var shift = Shift.build(workplace);
  		shifts.append_shift(shift, left, width);
  		shift.save();
  	}
  });

  Shifts.prototype = $.extend(new Resource, {
    init: function() {
      this.render_hours();
    },
    day: function() {
      return this.element.closest('.day');
    },
  	append_shift: function(shift, left, width) {
  		shift.element.css({ left: left });
  		// shift.expand_animated(width);
  		shift.width(width);
  		shift.update_data_from_dimension();
  		this.element.append(shift.element);
  	},
    bind_events: function() {
      this.element.droppable({
       accept: "#workplaces a div, .plan .requirement, .plan .assignment",
       tolerance: 'touch',
       greedy: true,
       drop: Shifts.on_drop
      });
    },
    render_hours: function() {
      var hours = $('<ul class="hours">');
      this.day().append(hours);
      for(var i = Plan.start(); i < Plan.end(); i += 60) {
        var hour = $('<li class="hour">' + (i / 60) + '</li>').css({
          width: Plan.pixels_per_hour()
        });
        hours.append(hour).css;
      }
    },
  });

  Resource.types.push(Shifts);

}.apply(Plan));
