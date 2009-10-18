(function() {
  Assignment = function(element) {
  	Resource.call(this, Assignment, element);
  };

  $.extend(Assignment, Resource, {
  	selector: ".assignment",
  });

  Assignment.prototype = $.extend(new Resource, {
    requirement: function() {
      return this.element.closest('.requirement').requirement();
    },
    assignee_id: function() {
      var matches = this.element.attr('class').match(/employee_(\d+)/);
      if(matches) return matches[1];
    },
  	bind_events: function() {
  		this.element.draggable({
  			helper: 'clone'
  		});
  	},
  	remove: function() {
  	  this.destroy();
  	  Resource.prototype.remove.call(this);
  	},
  	serialize: function() {
  	  return 'assignment[requirement_id]=' + this.requirement().id() +
  	         '&assignment[assignee_id]=' + this.assignee_id();
  	},
  	on_create: function(data, textStatus) {
  	  $('#requirement_' + data['assignment']['requirement_id'] + ' .assignment').attr('id', 'assignment_' + data['assignment']['id']);
  	},
  	on_update: function(data, textStatus) {
  	  // ...
  	}
  });
  
  Resource.types.push(Assignment);
}.apply(Plan));
