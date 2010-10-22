Plan = {
  slot_width: 18,
  slots_per_hour: 4,
  default_slot_count: 12,
  init: function() {
    $('#main').css({ width: Plan.width() + 12 + 'px' });
    $('#plan').css({ width: Plan.width() + 'px' });
    this.bind_events();
  },
  bind_events: function() {
    $("body").droppable({
      accept: ".requirement, .assignment",
      drop: Plan.on_element_remove,
    });
  },
  start: function() {
    return parseInt($('#plan').attr("data-start"));
  },
  duration: function() {
    return parseInt($('#plan').attr("data-duration"));
  },
  end: function() {
    return this.start() + this.duration();
  },
  hours: function() {
    return parseInt(this.duration() / 60);
  },
  width: function() {
    return Plan.hours() * Plan.slots_per_hour * Plan.slot_width + 1;
  },
  minutes_per_slot: function() {
    return parseInt(60 / Plan.slots_per_hour);
  },
  pixels_per_hour: function() {
    return Plan.slot_width * Plan.slots_per_hour;
  },
  pixels_per_minute: function() {
    return Plan.pixels_per_hour() / 60;
  },
  on_element_remove: function(event, ui) {
    ui.draggable.resource().remove();
  }
};
Plan.grid = [Plan.slot_width, 38],

$(document).ready(function() {
  if($('#plan').length > 0) Plan.init();
});
