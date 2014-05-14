@javascript
Feature: Signing in
  In order to protect my data from unauthorized access
  As a user
  I want my session to time out after 2 hours

  TODO: Data has to be entered again

        Currently we show the sign in form per AJAX, but submit it the
        classical way and redirect to the original page. This is caused by:

        * Signing in _may_ give the user a new CSRF token (plz check). Staying
          on the page would render all AJAX calls after sign_in invalid.
        * Ember does not remove the isDirty flag from the model that had failed
          saving (BUG), cannot add it to another transaction and thus looses a
          workable state. wait for Ember 1.0+

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario Outline: Session times out on HTML pages
    Given <scenario>
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie             |
        | 49   | 1     | 9-17                |
      And I am on the employees in week page for the plan for week: 49, cwyear: 2012
     When I click on the scheduling "09:00-17:00"
      And I wait for the modal box to appear
      And 2 hours pass
      And I press "Speichern"
      And I wait for a flash alert message to appear
     Then I should see flash alert "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within the modal box
     When I fill in "E-Mail" with "<email>" within the modal box
      And I fill in "Passwort" with "secret" within the modal box
      And I press "Einloggen"
     Then <result>
      And I should be on <page>

    Examples:
       | scenario                                                     | email                  | result                                        | page                                                                |
       | nothing                                                      | burns@clockwork.local  | I should see flash "Erfolgreich eingeloggt."  | the employees in week page for the plan for week: 49, cwyear: 2012  |
       | nothing                                                      | homer@clockwork.local  | I should see flash "Erfolgreich eingeloggt."  | the employees in week page for the plan for week: 49, cwyear: 2012  |
       | a confirmed user exists with email: "peter@clockwork.local"  | peter@clockwork.local  | nothing                                       | the dashboard                                                       |

  Scenario: Session times out when visiting notification hub
    Given 2 hours pass
     When I open the notification hub menu
      And I wait for the modal box to appear
     Then I should see flash alert "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within the modal box
     When I fill in "E-Mail" with "burns@clockwork.local" within the modal box
      And I fill in "Passwort" with "secret" within the modal box
      And I press "Einloggen"
      And I wait for the modal box to disappear
     Then I should see flash "Erfolgreich eingeloggt."
      And I should be on the employees in week page for the plan for week: 49, cwyear: 2012

  Scenario: Session times out on JSON requests (ie. Ember)
    Given a milestone exists with name: "Global Domination", plan: the plan
      And I am on the employees in week page for the plan for week: 49, cwyear: 2012
     When I follow "Global Domination"
      And I fill in "Name" with "World Domination"
      And 2 hours pass
      And I press "Speichern"
      And I wait for a flash alert message to appear
     Then I should see flash alert "Deine Sitzung ist abgelaufen, bitte melde Dich neu an." within "#modalbox"
     When I fill in "E-Mail" with "homer@clockwork.local" within "#modalbox"
      And I fill in "Passwort" with "secret" within "#modalbox"
      And I press "Einloggen"
     Then I should see flash notice "Erfolgreich eingeloggt."
      And I should be on the employees in week page for the plan for week: 49, cwyear: 2012
