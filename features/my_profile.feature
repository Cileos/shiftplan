@javascript
Feature: As a user
I want to edit my profile

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "marge@thebouviers.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Marge", last_name: "Bouvier"

  @fileupload
  Scenario: User with one employee edits her profile
    Given I am signed in as the confirmed user
     Then I should see a tiny gravatar within the navigation
     When I choose "Mein Profil" from the drop down "Marge Bouvier"
     Then I should be on the profile page of the employee
      # Marge Bouvier just married Homer Simpson and needs to change her last name
     When I fill in "Nachname" with "Simpson"
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
     Then I should be on the profile page of the employee
      And I should see "Profil gespeichert."
      And I should see "Marge Simpson" within the navigation
      And I should see the avatar "rails.png" within the navigation

  @fileupload
  Scenario: User with two employees edits her profile
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an employee "margeret" exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Margeret", last_name: "Bouvier"
      And I am signed in as the confirmed user
     Then I should see a tiny gravatar within the navigation
     When I choose "Mein Profil" from the drop down "marge@thebouviers.com"
     Then I should be on the profile page of my employees
     Then I should see the following table of employees:
       | Name             | Organisation     |
       | Margeret Bouvier | Tschernobyl GmbH |
       | Marge Bouvier    | Fukushima GmbH   |
     When I follow "Margeret Bouvier"
     Then I should be on the profile page of the employee "margeret"
      # Margeret Bouvier just married Homer Simpson and needs to change her last name
     When I fill in "Nachname" with "Simpson"
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
     Then I should see "Profil gespeichert."
      And I should see "Margeret Simpson" within the navigation
      And I should see the avatar "rails.png" within the navigation
