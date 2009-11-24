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
      var day = $(this).day();
  		var workplace = ui.draggable.workplace();
      var shifts = day.find_shifts(workplace) || day.append_shifts(workplace);
      
      var left = parseInt(ui.offset.left - this.offsetLeft - 1);
  		left = left - (left % Plan.slot_width);
  		var width = workplace.default_shift_length() ?
        workplace.default_shift_length() * Plan.pixels_per_minute() :
        Plan.slot_width * Plan.default_slot_count;
  		if(left + width > this.offsetWidth) {
  			width = this.offsetWidth - left - 1;
  		}

  		var shift = shifts.append_shift(workplace, left, width);
  		shift.save();
      shifts.adjust_shift_positions();
  	}
  });

  Shifts.prototype = $.extend(new Resource, {
    init: function() {
      this.adjust_shift_positions();
    },
    day: function() {
      return this.element.closest('.day').day();
    },
    empty: function() {
      return $('.shift', this.element).length == 0;
    },
  	append_shift: function(workplace, left, width) {
  		var shift = Shift.build(workplace);
  		// shifts.expand_animated(width);
  		shift.element.css({ position: 'absolute' }); // draggable adds position: relative
  		shift.left(left);
  		shift.width(width);
  		shift.update_data_from_dimension();
  		this.element.append(shift.element);
      return shift;
  	},
    adjust_shift_positions: function() {
      var last = null;
      $('.shift', this.element).each(function() {
        var shift = $(this).shift();
        var offset = last && (last.end() > shift.start()) ? 37 : 0;
        shift.top((last ? last.top() : 0) + offset);
        last = shift;
      });
      this.adjust_height();
    },
    adjust_height: function() {
      var max_height = 38;
      $('.shift', this.element).each(function() {
        var height = $(this).shift().top() + 38;
        if(max_height < height) max_height = height;
      });
      this.height(max_height);
    },
    bind_events: function() {
      this.element.droppable({
       accept: "#workplaces a div, .plan .requirement, .plan .assignment",
       tolerance: 'touch',
       greedy: true,
       drop: Shifts.on_drop
      });
    },
  });

  Resource.types.push(Shifts);

}.apply(Plan));


