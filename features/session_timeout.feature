Feature: Signing in
  In order to protect my data from unauthorized access
  As a user
  I want my session to time out

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  @javascript
  Scenario: Session times out after max 2 hours
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie             |
        | 49   | 1     | 9-17                |
      And I am on the employees in week page for the plan for week: 49, cwyear: 2012
     When I click on the scheduling "09:00-17:00"
      And I wait for the modal box to appear
      And 2 hours pass
      And I press "Speichern"
     Then I should see flash notice "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within the modal box
     When I fill in "E-Mail" with "homer@clockwork.local" within the modal box
      And I fill in "Passwort" with "secret" within the modal box
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the employees in week page for the plan for week: 49, cwyear: 2012

