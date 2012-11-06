@javascript
Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given the situation of a just registered user
      And a plan exists with name: "Kühlungsraum säubern", organization: the organization
     When I sign in as the confirmed user
      And I am on the employees page for the organization

  @fileupload
  Scenario: Creating an employee
    Given I should see the following table of employees:
      | Name | WAZ | E-Mail | Status |
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
      And I should see a thumb default gravatar within the new employee form
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      Then I should see the following table of employees:
        | Name           | WAZ  | E-Mail  | Status                 |
        | Carlson, Carl  | 30   |         | Noch nicht eingeladen  |
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
     When I go to the page of the plan
      And I should see the following calendar:
        | Mitarbeiter   | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl Carlson  |     |     |     |     |     |     |     |

  # The following scenario tests if the ajax multipart form really works.
  # Because ajax file uploads are not supported normally because of security reasons,
  # the 'remotipart' gem is used to tweak the handling of such forms.
  # We can test if it works by submitting the form with validation errors, e.g., leave
  # first name blank.
  # We should see error messages in the modal box which are prepended through the
  # javascript response.
  @fileupload
  Scenario: Creating an employee with avatar upload through ajax
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in "Nachname" with "Carlson"
      And I should see a thumb default gravatar within the new employee form
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
     Then I should see "Vorname muss ausgefüllt werden"
     When I fill in "Vorname" with "Carl"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      Then I should see the following table of employees:
        | Name           | WAZ  | E-Mail  | Status                 |
        | Carlson, Carl  | 40   |         | Noch nicht eingeladen  |
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
     When I go to the page of the plan
      And I should see the following calendar:
        | Mitarbeiter   | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl Carlson  |     |     |     |     |     |     |     |

  @fileupload
  Scenario: Uploading an avatar for myself on the employee page
    # At the moment the owner can not add itself to the organization in order to be able to schedule
    # itself and to appear in the employees list of the organization. This is a TODO.
    # So we manually create a membership for the owner "mr. burns" and the organization here.
    Given a membership exists with organization: the organization, employee: the employee "mr. burns"
      And I am on the employees page for the organization
      Then I should see the following table of employees:
        | Name          | WAZ  | E-Mail           | Status  |
        | Burns, Owner  |      | owner@burns.com  | Aktiv   |
     Then I should see a tiny gravatar within the row for employee "Owner Burns"
      And I should see a tiny gravatar within the user navigation
     When I follow "Burns, Owner" within the employees table
      And I wait for the modal box to appear
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the avatar "rails.png" within the row for employee "Owner Burns"
      And I should see the avatar "rails.png" within the user navigation

  @javascript
  Scenario: Changing my own name on employee page
    # At the moment the owner can not add itself to the organization in order to be able to schedule
    # itself and to appear in the employees list of the organization. This is a TODO.
    # So we manually create a membership for the owner "mr. burns" and the organization here.
    Given a membership exists with organization: the organization, employee: the employee "mr. burns"
      And I am on the employees page for the organization
      And I should see "Owner Burns" within the user navigation
     When I follow "Burns, Owner" within the employees table
      And I wait for the modal box to appear
     When I fill in "Nachname" with "Burns-Simpson"
      And I press "Speichern"
      And I wait for the modal box to disappear
      And I should see "Owner Burns-Simpson" within the user navigation

  Scenario: Trying to create an employee without a first name
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Nachname          | Carlson |
      And I press "Speichern"
     Then I should see "Vorname muss ausgefüllt werden"

  Scenario: Trying to create an employee without a last name
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
      And I press "Speichern"
     Then I should see "Nachname muss ausgefüllt werden"

  Scenario: Creating an employee without a weekly working time
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit |         |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."

  Scenario: Editing an employee
    Given an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization, employee: the employee "homer"
      And I am on the employees page for the organization
      Then I should see the following table of employees:
        | Name            | WAZ  | E-Mail  | Status                 |
        | Simpson, Homer  |      |         | Noch nicht eingeladen  |
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in the following:
        | Nachname | Simpson-Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see the following table of employees:
        | Name                    |
        | Simpson-Carlson, Homer  |

  Scenario: Normal user can not edit himself on the employees page
    Given a confirmed user "homer" exists
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account, user: the user "homer"
      And a membership exists with organization: the organization, employee: the employee "homer"

     When I sign in as the confirmed user "homer"
      And I go to the employees page for the organization
     Then I should see the following table of employees:
        | Name            |
        | Simpson, Homer  |
      And I should not see link "Simpson, Homer" within the employees table

  @javascript
  Scenario: removing WAZ from an employee
    Given an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And the employee "homer" is a member in the organization "fukushima"
      And I am on the employees page for the organization
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in "Wochenarbeitszeit" with ""
      And I press "Speichern"
      And I wait for the modal box to disappear
      And I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should be empty

  Scenario: Can only see employees of current organization
    Given another organization "Chefs" exists with account: the account
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization "Chefs", employee: the employee "homer"
      And I am on the employees page for the organization "fukushima"
     Then I should see the following table of employees:
        | Name |

     When I go to the employees page for the organization "Chefs"
     Then I should see the following table of employees:
        | Name            |
        | Simpson, Homer  |

