(function() {
  Day = function(element) {
  	Resource.call(this, Day, element);
  };

  $.extend(Day, Resource, {
  	selector: '.day',
  	on_drop: function(event, ui) {
  	  // document.title = 'DROPPED ONTO: ' + $(this).closest('.day').outerHTML();
  		switch(true) {
  			case ui.draggable.parent().hasClass('workplace'):
  				Day.on_workplace_drop.call(this, event, ui);
  				break;
  			default:
  				Plan.on_element_remove(event, ui);
  				break;
  		}
  	},
  	on_workplace_drop: function(event, ui) {
      // drops a workplace onto an empty day
      Shifts.on_workplace_drop.call(this, event, ui);
  	}
  });

  Day.prototype = $.extend(new Resource, {
    init: function() {
      this.render_hours();
    },
    find_shifts: function(workplace) {
      var element = $('.' + workplace.dom_id(), this.element)[0];
      if(element) return $(element).shifts();
    },
    append_shifts: function (workplace) {
      var shifts = $('<ul class="workplace ' + workplace.dom_id() + ' shifts"></ul>');
      this.element.append(shifts);
      return shifts.shifts();
    },
  	append_shift: function(day, left, width) {
  		shift.element.css({ left: left });
  		// shift.expand_animated(width);
  		shift.width(width);
  		shift.update_data_from_dimension();
  		this.element.append(shift.element);
  	},
    bind_events: function() {
      this.element.droppable({
       accept: "#workplaces a div, #plan .requirement, #plan .assignment",
       tolerance: 'touch',
       greedy: true,
       drop: Day.on_drop
      });
    },
    render_hours: function() {
      var hours = $('<ul class="hours">');
      this.element.after(hours);
      for(var i = Plan.start(); i < Plan.end(); i += 60) {
        var hour = $('<li class="hour">' + (i / 60) + '</li>').css({
          width: Plan.pixels_per_hour()
        });
        hours.append(hour).css;
      }
    },
  });

  Resource.types.push(Day);

}.apply(Plan));

