(function() {
  Employee = function(element) {
  	Resource.call(this, Employee, element);
  };

  $.extend(Employee, Resource, {
  	selector: ".employee",
  	by_ids: function(ids) {
  	  return $($.map(ids, function(id) { return '#employees .employee_' + id; }).join(','));
  	},
  	on_drag_start: function(event, ui) {
  	  var employee = ui.helper.employee();

      employee.mark_requirements()
  	  // var id = parseInt(employee.id()); // TODO move parseInt to id()
      // var available_on   = ui.helper.closest('.employee').attr('data-available-on');
      // var unavailable_on = ui.helper.closest('.employee').attr('data-unavailable-on');

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
  	},
  	qualifications: function() {
  	  return this.element.attr('data-qualifications').split(', ');
  	},
  	qualified_requirements: function() {
  	  return $($.map(this.qualifications(), function(qualification, ix) { return '.requirement.' + qualification }).join(','));
  	},
  	unqualified_requirements: function() {
  	  return $('.requirement:not(.' + this.qualifications().join(',') + ')');
  	},
  	mark_requirements: function() {
      this.qualified_requirements().addClass('qualified');
      this.unqualified_requirements().addClass('unqualified');
      // add class 'qualified' to all shifts that have at least one qualified requirement
      // add class 'unqualified' to all shifts that do not have any qualified requirement
      $('.shift .requirement.qualified').each(function() { $(this).shift().element.addClass('qualified') });
      $('.shift:not(.requirement.qualified)').each(function() { $(this).shift().element.addClass('unqualified') });
  	}
  });

  Resource.types.push(Employee);

}.apply(Plan));
