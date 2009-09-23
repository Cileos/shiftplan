function Workplace(element) {
	Resource.call(this, Workplace, element);
};

$.extend(Workplace, Resource);

$.extend(Workplace, {
	selector: ".workplace",
});

Workplace.prototype = $.extend(new Resource, {
  init: function() {
    this.element.prepend('<div></div>')    
  },
	bind_events: function() {
		$('div', this.element).draggable({
			helper: 'clone'
		});
	},
	name: function() {
		return this.element[0].innerHTML.replace(/<\/?[^>]+>/gi, '');
	},
});

