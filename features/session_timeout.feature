Feature: Signing in
  In order to protect my data from unauthorized access
  As a user
  I want my session to time out after 2 hours

  TODO: Datahas to be entered again

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  @javascript
  Scenario: Session times out on HTML pages
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie             |
        | 49   | 1     | 9-17                |
      And I am on the employees in week page for the plan for week: 49, cwyear: 2012
     When I click on the scheduling "9-17"
      And I wait for the modal box to appear
      And 2 hours pass
      And I press "Speichern"
     Then I should see flash alert "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within the modal box
     When I fill in "E-Mail" with "homer@clockwork.local" within the modal box
      And I fill in "Passwort" with "secret" within the modal box
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the employees in week page for the plan for week: 49, cwyear: 2012


  @javascript
  Scenario: Session times out on JSON requests (ie. Ember)
    Given a milestone exists with name: "Global Domination", plan: the plan
      And I am on the employees in week page for the plan for week: 49, cwyear: 2012
     When I follow "Global Domination"
      And I fill in "Name" with "World Domination"
      And 2 hours pass
      And I press "Speichern"
     Then I should see flash alert "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within the modal box
     When I fill in "E-Mail" with "homer@clockwork.local" within the modal box
      And I fill in "Passwort" with "secret" within the modal box
      And I press "Einloggen"
     Then I should see flash notice "Erfolgreich eingeloggt."
      And I should be on the employees in week page for the plan for week: 49, cwyear: 2012
