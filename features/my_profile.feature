Feature: As a user
I want to edit my profile

  Background:
    Given an account exists
      And an organization "fukushima" exists with name: "Fukushima GmbH", account: the account
      And a confirmed user exists with email: "marge@thebouviers.com"
      And an employee exists with user: the confirmed user, first_name: "Marge", last_name: "Bouvier", account: the account
      And the employee is a member of the organization "fukushima"

  Scenario: Editing the lastname on the my profile page
    Given I am signed in as the confirmed user
      And I am on the page for the organization "fukushima"
     Then I should see "Marge Bouvier" within the navigation

     When I choose "Einstellungen" from the drop down "Marge Bouvier"
     Then I should be on the profile page of the employee
      # Marge Bouvier just married Homer Simpson and needs to change her last name
     When I fill in "Nachname" with "Simpson"
      And I press "Speichern"
     Then I should be on the profile page of the employee
      And I should see "Profil gespeichert."
      And I should see "Marge Simpson" within the navigation
      But I should not see "Zurück"

  @fileupload
  Scenario: Editing the avatar on the my profile page
    Given I am signed in as the confirmed user
      And I am on the page for the organization "fukushima"
     Then I should see a tiny gravatar within the navigation

     When I choose "Einstellungen" from the drop down "Marge Bouvier"
     Then I should be on the profile page of the employee
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"
     Then I should be on the profile page of the employee
      And I should see "Profil gespeichert."
      And I should see the avatar "rails.png" within the navigation

  Scenario: Edit my full name for one of the accounts I joined
    Given the confirmed user has joined another account with organization_name: "Tschernobyl GmbH", as: "Margeret Bouvier"
      And I am signed in as the confirmed user
      And I am on the dashboard page

     When I choose "Einstellungen" from the drop down "marge@thebouviers.com"
     Then I should be on the profile page of my employees
     Then I should see the following table of employees:
       | Name              | Organisation     |
       | Bouvier, Marge    | Fukushima GmbH   |
       | Bouvier, Margeret | Tschernobyl GmbH |
     When I follow "Bouvier, Margeret"
      # Margeret Bouvier just married Homer Simpson and needs to change her last name
      And I fill in "Nachname" with "Simpson"
      And I press "Speichern"
     Then I should see "Profil gespeichert."
      And I should see "Margeret Simpson" within the navigation

     When I follow "Zurück"
     Then I should be on the profile page of my employees
     Then I should see the following table of employees:
       | Name              | Organisation     |
       | Bouvier, Marge    | Fukushima GmbH   |
       | Simpson, Margeret | Tschernobyl GmbH |

   Scenario: handle employee beeing member in multiple organizations
     Given an organization "Tepco" exists with name: "Tepco"
      And the employee is a member of the organization "Tepco"
      And I am signed in as the confirmed user
     When I go to the profile page of my employees
     Then I should see the following table of employees:
       | Name           | Organisation          |
       | Bouvier, Marge | Fukushima GmbH\nTepco |

