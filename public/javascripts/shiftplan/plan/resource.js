function Resource(type, element) {
	if(element) {
		this.type = type;
		this.element = element;
		Resource.register(this);
	}
};

$.extend(Resource, {
	type_names: function() {
		var type_names = $.map(this.types, function(type) {
			return type.type_name();
		});
		this.type_names = function() { return type_names; }
		return type_names;
	},
	type_map: function() {
		var map = {}
		for(var i = 0; i < Resource.types.length; i++) {
			map[Resource.types[i].class_name()] = Resource.types[i];
		}
		this.type_map = function() { return map; }
		return map;
	},
	class_names: function() {
		var class_names = $.map(this.type_names(), function(name) { return name.toLowerCase(); })
		this.class_names = function() { return class_names; }
		return class_names;
	},
	type_name: function() {
		var matches = this.toString().match(/function\s+([\w]*)\s?\(/);
		this.type_name = function() { return matches[1]; }
		return matches[1];
	},
	class_name: function() {
		var class_name = this.type_name().toLowerCase();
		this.class_name = function() { return class_name; }
		return class_name;
	},
	collection_name: function() {
	  var collection_name = this.class_name() + 's'; // FIXME
	  this.collection_name = function() { return collection_name; }
	  return collection_name;
	},
	elements: function() {
		return $(this.selector);
	},
	all: function() {
		var type = this;
		return objects = this.elements().map(function() {
			return $(this).resource(type)
		});
	},
	init: function() {
		$.each(this.all(), function() {
			if(this.init) this.init();
			this.bind_events();
		})
	},
	register: function(resource) {
		resource.element.data('resource', resource);
	},
	remove: function(resource) {
		resource.element.data('resource', null);
	},
	lookup: function(element) {
		return element.data('resource');
	},
	get: function(type, elements) {
		var resources = []; // FIXME return a jquery Object instead
		for(var i = 0; i < elements.length; i++) {
			var element = elements.eq(i);
			var resource = this.lookup(element);
			resources.push(resource ? resource : new type(element));
		}
		return elements.length == 1 ? resources[0] : resources;
	},
	id: function(element) {
	}
});

Resource.prototype = {
	id: function() {
		var source = this.element.attr('id');
		source = source ? source : this.element.attr('href');

    var regexp = new RegExp('[' + this.type.collection_name() + '|' + this.type.class_name() + ']' + '[/_](\\d+)$');
		var matches = source ? source.match(regexp) : null;
		if(matches) {
		  this.id = function() { return matches[1]; }
			return matches[1];
		} else {
		  this.id = function() { return null; }
			return null;
		}
	},
  is_new_record: function() {
    return this.id() == null;
  },
	href: function() {
		return this.element.attr('href');
	},
	class_names: function() {
		return this.element.attr('class').split(/\s+/);
	},
	dom_id: function() {
	  if(this.id()) {
		  return this.type.class_name() + '_' + this.id();
		}
	},
	left: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('left'));
		} else {
			this.element.css('left', arguments[0]);
		}
	},
	width: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('width'));
		} else {
			this.element.css('width', arguments[0]);
		}
	},
	remove: function(element) {
		this.element.remove();
		return Resource.remove(this);
	},
  save: function() {
	  if(this.is_new_record()) {
	    var url  = '/' + this.type.collection_name();
	    var type = 'post';
	  } else {
	    var url  = '/' + this.type.collection_name() + '/' + this.id();
	    var type = 'put';
	  }

		$.ajax({
		  'url': url,
		  'type': type,
		  'data': this.serialize(),
		  'dataType': 'json',
		  'success': this.is_new_record() ? this.on_create : this.on_update
		});
	}
};