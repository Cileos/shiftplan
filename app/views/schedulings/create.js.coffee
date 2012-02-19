<%= decorate resource.concurrent do |filter| %>
  <% if resource.errors.empty? %>
    $("<%= filter.cell_selector_for_scheduling(@scheduling) %>").html("<%= j filter.cell_content_for_scheduling(@scheduling) %>")
    $("<%= filter.hours_selector_for(@scheduling.employee) %>").html("<%= filter.hours_for(@scheduling.employee) %>")
    $("#<%= filter.scheduling_form_id %>").modal('hide')
  <% else %>
    $("#<%= filter.scheduling_form_id %> .errors").remove()
    $("#<%= filter.scheduling_form_id %> form").append('<p class="alert alert-error errors"><%=j resource.errors.full_messages.to_sentence %></p>')
  <% end %>
<% end %>
