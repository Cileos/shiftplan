@javascript
@big_screen
Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given an organization exists with name: "Fukushima GmbH"
      And a confirmed user exists
      And an employee planner exists with first_name: "Homer", last_name: "Simpson", user: the confirmed user, organization: the organization
     When I sign in as the confirmed user
      And I am on the employees page for the organization

  @fileupload
  Scenario: Creating an employee
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
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      And I should see "Carlson, Carl"
      And I should see "30"
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
      And I should see a tiny gravatar within the row for employee "Homer Simpson"
     When I follow "Carlson, Carl" within the employees table
      And I wait for the modal box to appear
     Then I should see the avatar "rails.png" within the edit employee form

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
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      And I should see "Carlson, Carl"
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
      And I should see a tiny gravatar within the row for employee "Homer Simpson"
     When I follow "Carlson, Carl" within the employees table
      And I wait for the modal box to appear
     Then I should see the avatar "rails.png" within the edit employee form

  @fileupload
  Scenario: Uploading an avatar for myself on employee page
     Then I should see a tiny gravatar within the row for employee "Homer Simpson"
      And I should see a tiny gravatar within the user navigation
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the avatar "rails.png" within the row for employee "Homer Simpson"
      And I should see the avatar "rails.png" within the user navigation

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
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit |         |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."

  Scenario: Editing an employee
    Given I should not see "Carlson, Carl"
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname  | Carl    |
        | Nachname | Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see "Carlson, Carl"
      But I should not see "Simpson, Homer"

  Scenario: Can only see employees of own organization
    Given another organization "Chefs" exists
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

      And I follow "Mitarbeiter"
     Then I should see "Simpson, Homer"
      But I should not see "Smithers"

