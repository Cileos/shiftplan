(function() {
  Employee = function(element) {
  	Resource.call(this, Employee, element);
  };

  $.extend(Employee, Resource, {
  	selector: ".employee",
  	on_drag_start: function(event, ui) {
      var workplaces = ui.helper.closest('.employee').attr('data-possible-workplaces');
      if(workplaces.length != 0) {
        workplaces = $.map(workplaces.split(/,\s?/), function(workplace) {
          return '.' + workplace;
        });
        $('.shift:not(' + workplaces.join(',') + ')').addClass('unsuitable_workplace');
      }
  	},
  	on_drag_stop: function(event, ui) {
  	  //$('.unsuitable_workplace').removeClass('unsuitable_workplace');
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
