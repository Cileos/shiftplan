Feature: Signing in
  In order to protect my data and to only see my data
  As a visitor
  I want to sign in

  # TODO distinguish between
  #
  #   a) a user with one employee beeing member in 2+ organizations belonging to the same account
  #   a) a user with one employee beeing member in 2+ organizations belonging to different accounts

  Background:
    Given an account exists
      And an organization "fukushima" exists with name: "Fukushima GmbH", account: the account
      And a confirmed user exists with email: "bart@thesimpsons.com"
      And an employee exists with user: the confirmed user, first_name: "Bart", last_name: "Simpson", account: the account
      And the employee is a member in the organization "fukushima"

  Scenario: User with one employee signing in and signing out successfully
    Given I am on the home page
     When I follow "Einloggen"
      And I fill in "E-Mail" with "bart@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the page for the organization "fukushima"
      And I should be signed in as "Bart Simpson"
     When I follow "Ausloggen"
     Then I should be on the sign in page
      And I should see "Einloggen"
      And I should see a flash notice "Erfolgreich ausgeloggt."
      But I should not see a flash alert message

  Scenario: User with two employees signing in successfully
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an employee "Bart" exists with user: the confirmed user, first_name: "Bart", last_name: "Simpson"
      And the employee "Bart" is a member in the organization "tschernobyl"

    Given I am on the home page
     When I follow "Einloggen"
      And I fill in "E-Mail" with "bart@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the dashboard page
      And I should be signed in as "bart@thesimpsons.com"
