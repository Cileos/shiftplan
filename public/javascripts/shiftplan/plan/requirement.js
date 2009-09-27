function Requirement(element) {
	Resource.call(this, Requirement, element);
};

$.extend(Requirement, Resource);

$.extend(Requirement, {
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
	employee_id: function() {
		var matches = this.element.attr('class').match(/employee_(\d+)/);
    if(matches) return matches[1];
	},
	assign_employee: function(employee) {
	  this.unassign_employees();
	  // FIXME - href could have something like /assignments/1?
		element = $('<a class="assignment ' + employee.dom_id() + '" href="#"></a>');
		this.element.append(element);
		var assignment = $(element).assignment();
		assignment.save();
		assignment.bind_events();
		return assignment;
	},
	unassign_employees: function() {
	  $(Assignment.selector, this.element).remove();
	},
	add_qualification: function(qualification) {
		if(qualification.dom_id()) {
			this.element.addClass(qualification.dom_id());
		}
	},
	bind_events: function() {
		$(".requirement").draggable({
			helper: 'clone'
		});
		$(".requirement").droppable({
			accept: ".employee div",
			drop: Requirement.on_employee_drop
		});
	},
	serialize: function() {
	  return 'requirement[shift_id]=' + this.shift().id() +
           '&requirement[qualification_id]=' + this.qualification_id();
	},
 	on_create: function(data, textStatus) {
 	  // ...
 	},
 	on_update: function(data, textStatus) {
 	  // ...
 	}
});

