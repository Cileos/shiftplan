$('.staff_requirement.new').live('click', function() {
  var element = $(this);
  var container = element.closest('.staff_requirement_container');
  container.find('ul').append('<li class="staff_requirement delete"></li>');
  var quantity = container.find('.required_quantity');
  quantity.val(parseInt(quantity.val()) + 1);
});

$('.staff_requirement.delete').live('click', function() {
  var element = $(this);
  if(element.siblings('.staff_requirement.delete').length < 1) return;
  var quantity = element.closest('.staff_requirement_container').find('.required_quantity');
  element.remove();
  quantity.val(parseInt(quantity.val()) - 1);
});

// yuck - Just So It Works For The Moment™
var build_requirement = function(index, requirement_id, qualification_id, qualification_name, quantity) {
  var html = '<li id="workplace_requirements_' + qualification_id + '" class="staff_requirement_container" data-index="' + index + '">';

  // for existing requirements, we need the id and the _destroy flag
  if(requirement_id && requirement_id != null) {
    html += '<input type="hidden" id="workplace_workplace_requirements_attributes_' + index + '_id" name="workplace[workplace_requirements_attributes][' + index + '][id]" value="' + requirement_id + '" />';
    html += '<input type="hidden" id="workplace_workplace_requirements_attributes_' + index + '_destroy" class="delete" name="workplace[workplace_requirements_attributes][' + index + '][_destroy]" value="0" />';
  }
  html += '<input type="hidden" id="workplace_workplace_requirements_attributes_' + index + '_qualification_id" name="workplace[workplace_requirements_attributes][' + index + '][qualification_id]" value="' + qualification_id + '" />';
  html += '<input type="hidden" id="workplace_workplace_requirements_attributes_' + index + '_quantity" name="workplace[workplace_requirements_attributes][' + index + '][quantity]" class="required_quantity" value="' + quantity + '" />';

  html += '<h3>' + qualification_name + '</h3>';
  html += '<ul>';
  html += '<li class="staff_requirement new">+</li>';
  for(var i = 0; i < quantity; i++) {
    html += '<li class="staff_requirement delete"></li>';
  }
  html += '</ul>';
  html += '</li>';

  return html;
};

$('#list .workplace').live('click', function(event) {
  var container = $('#sidebar #staff_requirements');
  container.empty();
  var workplace_requirements = eval('(' + $(this).attr('data-workplace-requirements') + ')');

  if(typeof workplace_requirements == 'undefined') return;

  $.each(workplace_requirements, function(idx) {
    container.append(build_requirement(idx, this['id'], this['qualification']['id'], this['qualification']['name'], this['quantity']));
  });
});

$('#sidebar #required_qualifications input:checkbox').live('change', function(event) {
  var qualification_id = $(this).val();
  var element          = $('#workplace_requirements_' + qualification_id);

  if($(this).is(':checked')) {
    if(element.length == 1) { // 'undelete' it
      $('input.delete', element).val(0);
      element.show();
    } else { // create it
      var container          = $('#sidebar #staff_requirements');
      var last_index         = parseInt($('li.staff_requirement_container:last', container).attr('data-index'));
      var index              = isNaN(last_index) ? 0 : last_index + 1;
      var qualification_name = $(this).siblings('label').html();
      var quantity           = 1;
      container.append(build_requirement(index, null, qualification_id, qualification_name, quantity));
    }
  } else {
    $('input.delete', element).val(1);
    element.hide();
  }
});
