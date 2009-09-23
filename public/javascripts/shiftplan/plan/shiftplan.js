Resource.types = [Shifts, Shift, Requirement, Assignment, Employee, Workplace, Qualification];

var Shiftplan = {
	resource: function(type) {
		if(type == undefined) {
			type = this.resource_type();
		}
		var element = this.closest(type.selector);
		if(element.length == 0) {
			throw('Could not find any (parent) element matching the selector ' + type.selector + '.');
		}
		return Resource.get(type, element);
	},
	resource_type: function() {
		return Resource.type_map()[this.resource_class_name()];
	},
	resource_class_name: function() {
		var class_names = this.attr('className').split(' ')
		class_names = class_names.intersect(Resource.class_names());
		if(class_names.length > 1) {
			throw("multiple resource type class names found: " + class_names.join(', '))
		}
		return class_names[0];
	}
};
$.each(Resource.types, function() {
	var type = this;
	Shiftplan[this.class_name()] = function() {
		return this.resource(type);
	}
})

jQuery.each(Shiftplan, function(name) {
  jQuery.fn[name] = this;
});

