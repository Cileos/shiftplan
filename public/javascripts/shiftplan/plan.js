var requirement_options = {
	grid: [0, 15],
	handles: 's, n'
};

$(document).ready(function() {
  $('.slot').live('dblclick', function() {
  	element = $(this);

  	var workplace_id = element.closest('.workplace').attr('data-workplace-id');

  	var match = element.attr('data-time').match(/^0?(\d*):(\d{2})/);

  	var start_time = new Date();
  	start_time.setHours(parseInt(match[1]));
  	start_time.setMinutes(parseInt(match[2]));

  	var end_time = new Date(start_time);
  	end_time.setHours(start_time.getHours() + 1);

  	var html = '<div class="requirement unstaffed workplace_' + workplace_id + '"></div>';
  	var children = element.children('.requirement').length;
  	var minutes = (end_time - start_time) / (60 * 1000);

  	element.append($(html).attr('data-quantity', 1).
  	                       attr('data-start-time', [start_time.getHours(), start_time.getMinutes()].join(':')).
  	                       attr('data-end-time', [end_time.getHours(), end_time.getMinutes()].join(':')).
  												 css({'height': minutes.toString() + 'px', 'margin-left': (children * 20).toString() + 'px'}).
  												 resizable(requirement_options));
  });

  $('.requirement').live('dblclick', function() {
  	$(this).append('<form class="edit_requirement"><label for="quantity">Quantity</label><input id="quantity" type="text" /></form>');
  });

  $('.requirement').resizable(requirement_options);
});