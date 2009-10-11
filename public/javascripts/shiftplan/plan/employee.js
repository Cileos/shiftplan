function Employee(element) {
	Resource.call(this, Employee, element);
};

$.extend(Employee, Resource);

$.extend(Employee, {
	selector: ".employee",
	on_drag_start: function(event, ui) {
	  // TODO: should also take into account that the employee might already be assigned to this or another shift
    // var possible_workplaces = ui.helper.closest('.employee').attr('data-possible-workplaces').split(', ');
    // $('.shift:not(.' + possible_workplaces.join(', .') + ')').addClass('unsuitable_workplace');
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

