(function() {
  Shift = function(element) {
  	Resource.call(this, Shift, element);
  };

  $.extend(Shift, Resource, {
  	selector: '.shift',
  	build: function(workplace) {
  	  // TODO: can we clean this up somehow?
      var html = '<li id="new_shift" class="shift ' + workplace.dom_id() + '" data-workplace-id="' + workplace.id() + '"><h3>' + workplace.name() + '</h3><ul class="requirements">';
      for(var i = 0; i < workplace.default_staffing().length; i++) {
        html += '<li class="requirement qualification_' + workplace.default_staffing()[i] + ' ui-draggable ui-droppable"></li>';
      }
      html += '</ul></li>';

  		var shift = $(html).shift();
  		shift.init();
  		return shift;
  	},
  	pixels_to_minutes: function(pixels) {
  		return pixels / Plan.pixels_per_minute();
  	},
  	minutes_to_pixels: function(minutes) {
  		return minutes * Plan.pixels_per_minute();
  	},
  	unmark_employees: function() {
	    $('#employees .employee').removeClass('available').removeClass('unavailable').removeClass('qualified').removeClass('unqualified');
  	},
    on_mousedown: function(event) {
      $(this).shift().click_cancelled(false);
    },
  	on_click: function(event) {
  	  var shift = $(this).shift();
      if(shift.click_cancelled()) return;

      Shift.unmark_employees();

  	  if(shift.selected()) {
  	    shift.element.removeClass('selected');
  	  } else {
  	    $('#plan .selected').removeClass('selected');
  	    shift.element.addClass('selected');
  	    shift.mark_employees();
  	  }
  	},
  	on_drag_stop: function(event, ui) {
  	  var shift = ui.helper.shift();
  	  if(shift.removing) {
  	    shift.remove();
  	    Cursor.hide();
        Cursor.poof();
  	  } else {
    		shift.update_data_from_dimension();
        shift.shifts().adjust_shift_positions();
    		shift.save(); // TODO only save if modified
    	}
      event.stopPropagation();
      shift.click_cancelled(true);
  	},
  	on_resize: function(event, ui) {
  		var shift = $(this).shift();
  		var draggable = $(this).data('draggable');
  		shift.init_containment(draggable);

  		if($(this).hasClass('left')) {
  			shift.left(shift.left() + ui.position.left);
  			shift.width(shift.width() - ui.position.left);
  			draggable.offset.parent.left = draggable.offset.parent.left + ui.position.left;
  		} else {
  			shift.width(ui.position.left + ui.helper.width());
  		}
  	},
  	on_qualification_drop: function(event, ui) {
  		$(this).shift().add_requirement($(ui.draggable).qualification());
  	}
  });

  Shift.prototype = $.extend(new Resource, {
    init: function() {
      var handles = $('<span class="resize_handle left"></span><span class="resize_handle right"></span>');
      this.element.append(handles);
      this.update_dimension_from_data();
    },
    shifts: function() {
      return this.element.closest('.shifts').shifts();
    },
    selected: function() {
      return this.element.hasClass('selected');
    },
    available_employee_ids: function() {
      return eval($(this.element).attr("data-available_employee_ids")) || [];
    },
    unavailable_employee_ids: function() {
      return eval($(this.element).attr("data-unavailable_employee_ids")) || [];
    },
    qualifications: function() {
      return eval($(this.element).attr("data-qualifications")) || [];
    },
    available_employees: function() {
      return Employee.by_ids(this.available_employee_ids());
    },
    unavailable_employees: function() {
      return Employee.by_ids(this.unavailable_employee_ids());
    },
    qualified_employees: function() {
      return $($.map(this.qualifications(), function(qualification) { return '.employee.' + qualification }).join(','));
    },
    unqualified_employees: function() {
      return $('.employee:not(.' + this.qualifications().join(',') + ')');
    },
    mark_employees: function() {
	    this.available_employees().addClass('available');
	    this.unavailable_employees().addClass('unavailable');
	    this.qualified_employees().addClass('qualified');
	    this.unqualified_employees().addClass('unqualified');
    },
  	init_containment: function(draggable) { // gotta set containment directly to the draggable
  		if (!draggable.containment) { draggable.containment = this.containment(); }
  	},
  	containment: function() {
  		var container = this.container();
  		var left = container.position().left;
  		var top = this.element.position().top;
  		return [left, top, left + container.width(), top + this.element.height()];
  	},
  	container: function() {
  		return this.element.closest('.shifts');
  	},
  	workplace_id: function() {
  	  if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-workplace-id'));
  		} else {
  			this.element.attr('data-workplace-id', arguments[0]);
  		}
  	},
  	day: function() {
  	  return this.element.closest('.day').attr('data-day'); // hmmm?
  	},
  	start: function() {
  		if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-start'));
  		} else {
  			this.element.attr('data-start', arguments[0]);
  		}
  	},
    end: function() {
      return this.start() + this.duration();
    },
  	duration: function() {
  		if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-duration'));
  		} else {
  			this.element.attr('data-duration', arguments[0]);
  		}
  	},
  	serialize: function() {
  	  return 'shift[workplace_id]=' + this.workplace_id() +
             '&shift[day]=' + this.day() +
             '&shift[start]=' + this.start() +
             '&shift[duration]=' + this.duration();
  	},
  	remove: function() {
      var shifts = this.shifts();
  	  this.destroy();
  	  Resource.prototype.remove.call(this);
      shifts.empty() ? shifts.remove() : shifts.adjust_shift_positions();
  	},
  	add_requirement: function(qualification) {
  		var element = $('<li class="requirement"></li>');
  		$('.requirements', this.element).append(element);
  		var requirement = element.requirement();
  		requirement.add_qualification(qualification);
  		requirement.save();
  		requirement.bind_events();
  	},
  	update_dimension_from_data: function() {
  		this.left(Shift.minutes_to_pixels(this.start() - Plan.start()));
  		this.width(Shift.minutes_to_pixels(this.duration()));
  	},
  	update_data_from_dimension: function() {
  		this.element.attr({
  			'data-start': Shift.pixels_to_minutes(this.left()) + Plan.start(),
  			'data-duration': Shift.pixels_to_minutes(this.width())
  		});
  		// console.log('data updated to start: ' + this.element.attr('data-start') + ', duration: ' + this.element.attr('data-duration'));
  	},
  	expand_animated: function(width) {
  		this.element.animate({ width: width }, {
  			complete: function() { $(this).shift().update_data_from_dimension(); }
  		});
  	},
  	draggable: function() {
  	  return this.element.data('draggable');
  	},
  	shiftsDimensions: function() {
      if(!this.element.data('shiftsDimensions')) {
        var containment = this.element.data('draggable').containment;
        this.element.data('shiftsDimensions', {
          left:   containment[0] - 5,
          top:    containment[1] - 5,
          right:  containment[2] + this.element.width() + 5,
          bottom: containment[3] + this.element.height() + 5
        });
      }
      return this.element.data('shiftsDimensions');
  	},
  	shiftsDimensions: function() {
      if(!this.element.data('shiftsDimensions')) {
        var day = this.element.closest('.day')[0];
        this.element.data('shiftsDimensions', {
          left:   day.offsetLeft - 10,
          top:    day.offsetTop - 10,
          right:  day.offsetLeft + day.offsetWidth + 10,
          bottom: day.offsetTop + day.offsetHeight + 10
        });
      }
      return this.element.data('shiftsDimensions');
  	},
  	isOverShiftsBox: function(event) {
      var box = this.shiftsDimensions();
      return event.pageX >= box.left && event.pageX <= box.right &&
             event.pageY >= box.top  && event.pageY <= box.bottom

  	},
  	updateDragMode: function(event) {
      var over = this.isOverShiftsBox(event);
      if(over) {
        this.setDragAdjusting(event);
      } else if(!over) {
        this.setDragRemoving(event);
        Cursor.update_position(event.pageX, event.pageY + 10)
      }
  	},
  	setDragAdjusting: function(event) {
  	  if(this.removing) {
        this.removing = false;
  	    this.element[0].style.top = '0px';
  	    var draggable = this.draggable();
  	    $.extend(true, draggable, {
  	      containment: 'parent',
  	      options: { axis: 'x', grid: Plan.grid }
  	    });
  	    draggable._setContainment();
  	    Cursor.hide();
      }
  	},
  	setDragRemoving: function(event) {
  	  if(!this.removing) {
        this.removing = true;
  	    $.extend(true, this.draggable(), {
  	      containment: null,
  	      options: { axis: null, grid: null }
  	    });
        Cursor.show('poof');
      }
  	},
  	bind_events: function() {
      this.element.mousedown(Shift.on_mousedown);
      this.element.click(Shift.on_click);
      this.element.droppable({
        accept: "#qualifications a div",
        drop: Shift.on_qualification_drop
      });

      this.element.draggable({
        containment: 'parent',
        axis: 'x',
        grid: Plan.grid,
        stop: function(event, ui) {
          ui.helper.data('shiftsDimensions', null);
          Shift.on_drag_stop(event, ui);
        },
        drag: function(event, ui) {
          ui.helper.shift().updateDragMode(event);
        }
      });
      $(".resize_handle", this.element).draggable({
        axis: 'x',
        grid: Plan.grid,
        drag: Shift.on_resize,
        stop: Shift.on_drag_stop
      });
      // ugh. draggable adds style="position:relative" ... wtf? why's that?
      $(".resize_handle", this.element).css('position', null);
  	},
  	on_create: function(data, textStatus) {
      data = eval("(" + data + ")");
  	  var shift_id = 'shift_' + data['shift']['id'];
  	  var shift = $('#new_shift').attr('id', shift_id);
  	  $('.requirement', shift).each(function(index) {
  	    $(this).attr('id', 'requirement_' + data['shift']['requirements'][index]['id']);
  	  });
  	},
  	on_update: function(data, textStatus) {
      data = eval("(" + data + ")");
  	  // ...
  	},
  	on_destroy: function(data, textStatus) {
      data = eval("(" + data + ")");
  	  // ...
  	},
  });

  Resource.types.push(Shift);

}.apply(Plan));
