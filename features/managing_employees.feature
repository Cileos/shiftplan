Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given an organization exists with name: "Fukushima GmbH"
      And a confirmed user exists
      And a planner exists with first_name: "Homer", last_name: "Simpson", user: the confirmed user, organization: the organization
     When I sign in as the confirmed user
      And I follow "Fukushima GmbH"
      And I follow "Mitarbeiter"

  @javascript
  @fileupload
  Scenario: Creating an employee
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      And I should see "Carl Carlson"
      And I should see "30"
     When I follow "Carl Carlson"
      And I wait for the modal box to appear
     Then I should see the avatar "rails.png" for the employee "Carl Carlson"

  # The following scenario tests if the ajax multipart form really works.
  # Because ajax file uploads are not supported normally because of security reasons,
  # the 'remotipart' gem is used to tweak the handling of such forms.
  # We can test if it works by submitting the form with validation errors, e.g., leave
  # first name blank.
  # We should see error messages in the modal box which are prepended through the
  # javascript response.
  @javascript
  @fileupload
  Scenario: Creating an employee with avatar upload through ajax
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Nachname          | Carlson |
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
     Then I should see "Vorname muss ausgefüllt werden"
     When I fill in the following:
        | Vorname          | Carl |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      And I should see "Carl Carlson"
     When I follow "Carl Carlson"
      And I wait for the modal box to appear
     Then I should see the avatar "rails.png" for the employee "Carl Carlson"

  @javascript
  Scenario: Trying to create an employee without a first name
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Nachname          | Carlson |
      And I press "Speichern"
     Then I should see "Vorname muss ausgefüllt werden"

  @javascript
  Scenario: Trying to create an employee without a last name
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
      And I press "Speichern"
     Then I should see "Nachname muss ausgefüllt werden"

  @javascript
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

  @javascript
  Scenario: Editing an employee
      And I should be on the employees page for the organization
     Then I should not see "Carl Carlson"
     When I follow "Homer Simpson"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname  | Carl    |
        | Nachname | Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see "Carl Carlson"
      But I should not see "Homer Simpson"

  Scenario: Can only see employees of own organization
    Given another organization "Chefs" exists
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

      And I follow "Mitarbeiter"
     Then I should see "Homer Simpson"
      But I should not see "Smithers"

