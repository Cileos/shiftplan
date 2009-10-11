// $('.staff_requirement.new').live('click', function() {
//   var element = $(this);
//   var container = element.closest('.staff_requirement_container');
//   container.find('ul').append('<li class="staff_requirement"></li>');
//   var quantity = container.find('.required_quantity');
//   quantity.val(parseInt(quantity.val()) + 1);
// });
// 
// $('.staff_requirement:not(.new)').live('click', function() {
//   var element = $(this);
//   if(element.siblings('.staff_requirement:not(.new)').length < 1) return;
//   var quantity = element.closest('.staff_requirement_container').find('.required_quantity');
//   element.remove();
//   quantity.val(parseInt(quantity.val()) - 1);
// });
