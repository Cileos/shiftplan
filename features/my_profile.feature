@javascript
Feature: As a user
I want to edit my profile

  Scenario: User with one employee edits her profile
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "marge@thebouviers.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Marge", last_name: "Bouvier"
      And I am signed in as the confirmed user
     When I choose "Mein Profil" from the drop down "Marge Bouvier"
      # Marge Bouvier just married Homer Simpson and needs to change her last name
      And I fill in "Nachname" with "Simpson"
      And I press "Speichern"
     Then I should see "Mitarbeiter erfolgreich geändert"
      And I should see "Marge Simpson" within the navigation
