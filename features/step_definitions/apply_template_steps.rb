When /^I apply template #{capture_quoted} in modalbox$/ do |name|
  with_invariant_page_path do
    steps %Q{
     When I choose "Planvorlage anwenden" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
      And I select "#{name}" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
    }
  end
end

