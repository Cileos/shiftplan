function Assignment(element) {
	Resource.call(this, Assignment, element);
};

$.extend(Assignment, Resource);

$.extend(Assignment, {
	selector: ".assignment",
});

Assignment.prototype = $.extend(new Resource, {
	bind_events: function() {
		$(".assignment").draggable({
			helper: 'clone'
		});
	},
	remove: function() {
		this.element.remove();
	}
});

