(function() {
  Employee = function(element) {
  	Resource.call(this, Employee, element);
  };

  $.extend(Employee, Resource, {
  	selector: ".employee",
  	on_drag_start: function(event, ui) {
  	  var id = parseInt(ui.helper.employee().id()); // TODO move parseInt to id()
      var qualifications = ui.helper.closest('.employee').attr('data-qualifications');
      var workplaces = ui.helper.closest('.employee').attr('data-qualified-workplaces');

  	  // mask all shifts for which the employee is unavailable
      $('.shift').each(function() {
        if($(this).shift().unavailable_employee_ids().contains(id)) {
          $(this).addClass('unsuitable_workplace');
        }
      })

	    // mask all shifts that do not have a requirement for this employee's qualifications
      if(workplaces.length != 0) {
        var classes = $.map(workplaces.split(/,\s?/), function(workplace) { return '.' + workplace; });
        $('.shift:not(' + classes.join(',') + ')').addClass('unsuitable_workplace');
      }

	    // mask all requirements that do not fit this employee's qualifications
      if(qualifications.length != 0) {
        var classes = $.map(qualifications.split(/,\s?/), function(qualification) { return '.' + qualification; });
        $('.requirement:not(' + classes.join(',') + ')').addClass('unsuitable_workplace');
      }
  	},
  	on_drag_stop: function(event, ui) {
      $('.unsuitable_workplace').removeClass('unsuitable_workplace');
  	}
  });

  Employee.prototype = $.extend(new Resource, {
    init: function() {
      this.element.prepend('<div></div>')
    },
  	bind_events: function() {
  		$('div', this.element).draggable({
  			helper: 'clone',
  			start: Employee.on_drag_start,
  			stop: Employee.on_drag_stop
  		});
  	}
  });

  Resource.types.push(Employee);

}.apply(Plan));
