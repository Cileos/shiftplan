function Qualification(element) {
	Resource.call(this, Qualification, element);
};

$.extend(Qualification, Resource);

$.extend(Qualification, {
	selector: ".qualification",
});

Qualification.prototype = $.extend(new Resource, {
  init: function() {
    this.element.prepend('<div></div>')    
  },
	bind_events: function() {
		$('div', this.element).draggable({
			helper: 'clone'
		});
	}
});
