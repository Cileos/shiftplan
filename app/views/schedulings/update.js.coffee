<%= decorate @scheduling.concurrent do |filter| %>
$("<%= filter.cell_selector_for_scheduling(@scheduling) %>").html("<%= j filter.cell_content_for_scheduling(@scheduling) %>")
$("<%= filter.hours_selector_for(@scheduling.employee) %>").html("<%= filter.hours_for(@scheduling.employee) %>")
$("#<%= filter.scheduling_form_id %>").modal('hide')
<% end %>

