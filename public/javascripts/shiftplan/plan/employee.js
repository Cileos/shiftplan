function Employee(element) {
	Resource.call(this, Employee, element);
};

$.extend(Employee, Resource);

$.extend(Employee, {
	selector: ".employee",
});

Employee.prototype = $.extend(new Resource, {
  init: function() {
    this.element.prepend('<div></div>')    
  },
	bind_events: function() {
		$('div', this.element).draggable({
			helper: 'clone'
		});
	}
});

