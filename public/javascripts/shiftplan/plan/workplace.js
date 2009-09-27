function Workplace(element) {
	Resource.call(this, Workplace, element);
};

$.extend(Workplace, Resource);

$.extend(Workplace, {
	selector: ".workplace",
});

Workplace.prototype = $.extend(new Resource, {
  default_staffing: function() {
    return eval(this.element.attr('data-default-staffing'));
  },
  default_shift_length: function() {
    return parseInt(this.element.attr('data-default-shift-length'));
  },
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

