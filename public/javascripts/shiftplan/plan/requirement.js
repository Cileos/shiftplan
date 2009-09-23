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
	employee_id: function() {
		var class_names = this.class_names();
		for(var i = 0; i < class_names.length; i++) {
			var matches = class_names[i].match(/employee_(\d+)/);
			if(matches) return matches[1];
		}
	},
	assign_employee: function(employee) {
		element = $('<a class="assignment ' + employee.dom_id() + '" href="' + employee.href() + '"></a>');
		this.element.append(element);
		var assignment = $(element).assignment();
		assignment.bind_events();
		return assignment;
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
});

