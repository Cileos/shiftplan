<%= decorate @scheduling.plan do |p| %>
$("<%= p.cell_selector_for_scheduling(@scheduling) %>").html("<%= j p.quicky_list_for_scheduling(@scheduling) %>")
$("#<%= p.new_scheduling_dom_id %>.ui-dialog").dialog('close')
<% end %>
