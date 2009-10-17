(function() {
  Requirement = function(element) {
  	Resource.call(this, Requirement, element);
  };

  $.extend(Requirement, Resource, {
  	selector: ".requirement",
  	on_employee_drop: function(event, ui) {
  		var requirement = $(this).requirement();
  		var employee = $(ui.draggable).employee()
  		var assignment = requirement.assign_employee(employee);
  		assignment.element.effect('bounce', {}, 100);
  	}
  });

  Requirement.prototype = $.extend(new Resource, {
    shift: function() {
      return this.element.closest('.shift').shift();
    },
    qualification_id: function() {
      var matches = this.element.attr('class').match(/qualification_(\d+)/);
      if(matches) return matches[1];
    },
  	assign_employee: function(employee) {
  	  var assignment = $(Assignment.selector, this.element);

  	  if(assignment.size() > 0) {
  	    var assignment = assignment.assignment();
  	    assignment.element.removeClass('employee_' + assignment.employee_id()).addClass(employee.dom_id());
  	  } else {
  	    // FIXME - href could have something like /assignments/1?
    		element = $('<a class="assignment ' + employee.dom_id() + '" href="#"></a>');
    		this.element.append(element);
    		var assignment = $(element).assignment();
  	  }

  		assignment.save();
  		assignment.bind_events();
  		return assignment;
  	},
  	add_qualification: function(qualification) {
  		if(qualification.dom_id()) {
  			this.element.addClass(qualification.dom_id());
  		}
  	},
  	bind_events: function() {
  		this.element.draggable({
  			helper: 'clone'
  		});
  		this.element.droppable({
  			accept: ".employee div",
  			drop: Requirement.on_employee_drop
  		});
  	},
  	remove: function() {
  	  this.destroy();
  	  this.element.remove();
  	},
  	serialize: function() {
  	  return 'requirement[shift_id]=' + this.shift().id() +
             '&requirement[qualification_id]=' + this.qualification_id();
  	},
   	on_create: function(data, textStatus) {
   	  $('#shift_' + data['requirement']['shift_id'] + ' .requirement:not([id])').attr('id', 'requirement_' + data['requirement']['id']);
   	},
   	on_update: function(data, textStatus) {
   	  // ...
   	}
  });
  
  Plan.types.push(Requirement);

}.apply(Plan));

