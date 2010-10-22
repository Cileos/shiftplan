(function() {
  Requirement = function(element) {
    Resource.call(this, Requirement, element);
  };

  $.extend(Requirement, Resource, {
    selector: ".requirement",
    qualified_requirements: function(qualifications) {
      if(qualifications.length > 0) {
        var selector = Requirement.selector;
        return $($.map(qualifications, function(qualification, ix) { return '.requirement.' + qualification }).join(','));
      } else {
        return $([])
      }
    },
    qualified_requirements: function(qualifications) {
      var selector = qualifications.length > 0 ?
        $.map(qualifications, function(q) { return Requirement.selector + '.' + q }).join(',') : []
      return $(selector);
    },
    unqualified_requirements: function(qualifications) {
      var selector = Requirement.selector;
      if(qualifications.length > 0) { selector = selector + ':not(.' + qualifications.join(',') + ')' }
      return $(selector);
    },
    unmark: function() {
      $('.requirement').removeClass('qualified unqualified');
    },
    mark_qualifications: function(qualifications) {
      this.unmark();
      this.qualified_requirements(qualifications).addClass('qualified');
      this.unqualified_requirements(qualifications).addClass('unqualified');
    },
    on_employee_drop: function(event, ui) {
      var requirement = $(this).requirement();
      var employee = $(ui.draggable).employee()
      var assignment = requirement.assign_employee(employee);
      assignment.element.effect('bounce', {}, 100);
    },
    on_click: function(event) {
      event.preventDefault();
      event.stopPropagation();

      Employee.unmark();
      var requirement = $(this).requirement();
      if(requirement.selected()) {
        requirement.element.removeClass('selected');
      } else {
        $('#plan .selected').removeClass('selected');
        requirement.element.addClass('selected');
        requirement.mark_employees();
        requirement.shift().mark_employees();
      }
    }
  });

  Requirement.prototype = $.extend(new Resource, {
    shift: function() {
      return this.element.closest('.shift').shift();
    },
    qualification_id: function() {
      var matches = this.element.attr('class').match(/qualification_(\d+)/);
      if(matches) return matches[1];
    },
    assign_employee: function(employee) {
      var assignment = $(Assignment.selector, this.element);

      if(assignment.size() > 0) {
        var assignment = assignment.assignment();
        assignment.element.removeClass('employee_' + assignment.employee_id()).addClass(employee.dom_id());
      } else {
        // FIXME - href could have something like /assignments/1?
        element = $('<a class="assignment ' + employee.dom_id() + '" href="#"></a>');
        this.element.append(element);
        var assignment = $(element).assignment();
      }

      assignment.save();
      assignment.bind_events();
      return assignment;
    },
    add_qualification: function(qualification) {
      if(qualification.dom_id()) {
        this.element.addClass(qualification.dom_id());
      }
    },
    bind_events: function() {
      this.element.draggable({
        helper: 'clone'
      });
      this.element.droppable({
        accept: ".employee div",
        drop: Requirement.on_employee_drop
      });
      this.element.click(Requirement.on_click)
    },
    selected: function() {
      return this.element.hasClass('selected');
    },
    qualified_employee_ids: function() {
      return eval($(this.element).attr("data-qualified_employee_ids")) || [];
    },
    unqualified_employee_ids: function() {
      return Employee.ids().except(this.qualified_employee_ids());
    },
    mark_employees: function() {
      Employee.by_ids(this.qualified_employee_ids()).addClass('qualified');
      Employee.by_ids(this.unqualified_employee_ids()).addClass('unqualified');
    },
    remove: function() {
      this.destroy();
      Resource.prototype.remove.call(this);
    },
    serialize: function() {
      return 'requirement[shift_id]=' + this.shift().id() +
             '&requirement[qualification_id]=' + this.qualification_id();
    },
    on_create: function(data, textStatus) {
      data = eval("(" + data + ")");
      $('#shift_' + data['requirement']['shift_id'] + ' .requirement:not([id])').
        attr('id', 'requirement_' + data['requirement']['id']);
    },
    on_update: function(data, textStatus) {
      data = eval("(" + data + ")");
      // ...
    },
    on_destroy: function(data, textStatus) {
      data = eval("(" + data + ")");

      if(data['flash']) {
        $.each(data['flash'], function(type, message) {
          if(message != '') {
            $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
          }
        });
      }
    }
  });

  Resource.types.push(Requirement);

}.apply(Plan));

