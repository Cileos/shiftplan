# encoding: utf-8

Then /^the user should have the abilities of a planner in #{capture_model}$/ do |organization|
  organization = model!(organization)

  step %{I go to the home page}
  step %{I should be authorized to access the page}

  step %{I follow "#{organization.name}"}
  step %{I should be authorized to access the page}
  step %{I choose "Alle Pläne" from the drop down "Pläne"}
  step %{I should be authorized to access the page}
  organization.plans.each do |plan|
    step %{I should see link "#{plan.name}"}
  end
  step %{I should see link "Hinzufügen"}
  step %{I should see link "Mitarbeiter" within the navigation}
  step %{I should see link "Teams" within the navigation}

  organization.plans.each do |plan|
    step %{I choose "#{plan.name}" from the drop down "Pläne"}
    step %{I should be authorized to access the page}
    step %{I should see link "Neue Terminierung"}
    step %{I should see link "Übernahme aus der letzten Woche"}
    step %{I should see link "Planvorlage anwenden"}
  end

  step %{I follow "Mitarbeiter"}
  step %{I should be authorized to access the page}
  step %{I should see link "Hinzufügen"}

  step %{I follow "Teams"}
  step %{I should be authorized to access the page}
  step %{I should see link "Bearbeiten"}
  step %{I should see link "Hinzufügen"}
  step %{I should see button "Zusammenlegen"}

  step %{I follow "Qualifikationen"}
  step %{I should be authorized to access the page}
  step %{I should see link "Hinzufügen"}

  step %{I follow "Planvorlagen"}
  step %{I should be authorized to access the page}
  step %{I should see link "Hinzufügen"}
end

Then /^the user should have the abilities of an employee in #{capture_model}$/ do |organization|
  organization = model!(organization)

  step %{I go to the home page}
  step %{I should be authorized to access the page}

  step %{the user should not have the ability to crud the account or organizations}

  step %{I follow "#{organization.name}"}
  step %{I should be authorized to access the page}
  step %{I choose "Alle Pläne" from the drop down "Pläne"}
  step %{I should be authorized to access the page}
  organization.plans.each do |plan|
    step %{I should see link "#{plan.name}"}
  end
  step %{I should not see link "Hinzufügen"}
  step %{I should not see link "Mitarbeiter" within the navigation}
  step %{I should not see link "Mitarbeiter" within the navigation}
  step %{I should not see link "Qualifikationen" within the navigation}
  step %{I should not see link "Planvorlagen" within the navigation}

  organization.plans.each do |plan|
    step %{I follow "#{plan.name}"}
    step %{I should be authorized to access the page}
    step %{I should not see link "Neue Terminierung"}
    step %{I should not see link "Übernahme aus der letzten Woche"}
    step %{I should not see link "Planvorlage anwenden"}
  end
end

Then /^the user (should|should not) have the ability to crud the account or organizations$/ do |should_or_should_not|
  see_or_not_see = should_or_should_not == 'should' ? 'see' : 'not see'
  step %{I choose "Alle Organisationen" from the drop down "Organisationen"}
  step %{I should be authorized to access the page}
  step %{I should #{see_or_not_see} link "Account bearbeiten"}
  step %{I should #{see_or_not_see} link "Bearbeiten"}
  step %{I should #{see_or_not_see} link "Organisation hinzufügen"}
end
