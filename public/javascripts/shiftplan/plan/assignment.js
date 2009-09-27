function Assignment(element) {
	Resource.call(this, Assignment, element);
};

$.extend(Assignment, Resource);

$.extend(Assignment, {
	selector: ".assignment",
});

Assignment.prototype = $.extend(new Resource, {
  requirement: function() {
    return this.element.closest('.requirement').requirement();
  },
  employee_id: function() {
    var matches = this.element.attr('class').match(/employee_(\d+)/);
    if(matches) return matches[1];
  },
	bind_events: function() {
		$(".assignment").draggable({
			helper: 'clone'
		});
	},
	remove: function() {
	  this.destroy();
		this.element.remove();
	},
	serialize: function() {
	  console.log(this.type.class_name())
	  return 'assignment[requirement_id]=' + this.requirement().id() +
	         '&assignment[employee_id]=' + this.employee_id();
	},
	on_create: function(data, textStatus) {
	  // ...
	},
	on_update: function(data, textStatus) {
	  // ...
	}
});

