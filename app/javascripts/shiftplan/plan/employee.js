(function() {
  Employee = function(element) {
    Resource.call(this, Employee, element);
  };

  $.extend(Employee, Resource, {
    selector: ".employee",
    by_ids: function(ids) {
      return $($.map(ids, function(id) { return '#employees .employee_' + id; }).join(','));
    },
    unmark: function() {
      $('#employees .employee').removeClass('available unavailable qualified unqualified');
    },
    on_drag_start: function(event, ui) {
      var employee = ui.helper.employee();
      employee.mark_requirements();
      employee.mark_shifts()
    },
    on_drag_stop: function(event, ui) {
      Requirement.unmark();
      Shift.unmark();
    }
  });

  Employee.prototype = $.extend(new Resource, {
    init: function() {
      this.element.prepend('<div></div>')
    },
    bind_events: function() {
      $('div', this.element).draggable({
        helper: 'clone',
        start: Employee.on_drag_start,
        stop: Employee.on_drag_stop
      });
    },
    qualifications: function() {
      return eval(this.element.attr('data-qualifications')) || [];
    },
    mark_requirements: function() {
      Requirement.mark_qualifications(this.qualifications());
    },
    mark_shifts: function() {
      Shift.mark_availabilities_for(this);
      Shift.mark_qualifictions_from_requirements();
    }
  });

  Resource.types.push(Employee);

}.apply(Plan));
