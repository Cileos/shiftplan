(function() {
  Qualification = function(element) {
  	Resource.call(this, Qualification, element);
  };

  $.extend(Qualification, Resource, {
  	selector: ".qualification",
  	on_drag_start: function(event, ui) {
  	  // TODO: should also take into account that the employee might already be assigned to this or another shift
      // var possible_workplaces = ui.helper.closest('.qualification').attr('data-possible-workplaces').split(', ');
      // $('.shift:not(.' + possible_workplaces.join(', .') + ')').addClass('unsuitable_workplace');
  	},
  	on_drag_stop: function(event, ui) {
  	  $('.unsuitable_workplace').removeClass('unsuitable_workplace');
  	}
  });

  Qualification.prototype = $.extend(new Resource, {
    init: function() {
      this.element.prepend('<div></div>')    
    },
  	bind_events: function() {
  		$('div', this.element).draggable({
  			helper: 'clone',
  			start: Qualification.on_drag_start,
  			stop: Qualification.on_drag_stop
  		});
  	}
  });
  
  Plan.types.push(Qualification);

}.apply(Plan));
