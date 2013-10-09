Feature: Signing in
  In order to protect my data and to only see my data
  As a visitor
  I want to sign in

  # TODO distinguish between
  #
  #   a) a user with one employee beeing member in 2+ organizations belonging to the same account
  #   a) a user with one employee beeing member in 2+ organizations belonging to different accounts

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists

  Scenario: User with one employee signing in and signing out successfully
    Given I am on the home page
     When I follow "Einloggen"
      And I fill in "E-Mail" with "c.burns@npp-springfield.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the page for the organization "sector 7g"
      And I should be signed in as "Charles Burns"
     When I follow "Ausloggen"
     Then I should be on the sign in page
      And I should see "Einloggen"
      And I should see a flash notice "Erfolgreich ausgeloggt."
      But I should not see a flash alert message

  Scenario: User with two employees signing in successfully
    Given an organization "bingo club" exists with name: "Bingo Club"
      And an employee "charly" exists with user: user "mr burns", first_name: "Charly", last_name: "Burns"
      And the employee "charly" is a member in the organization "bingo club"

    Given I am on the home page
     When I follow "Einloggen"
      And I fill in "E-Mail" with "c.burns@npp-springfield.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the dashboard page
      And I should be signed in as "c.burns@npp-springfield.com"
