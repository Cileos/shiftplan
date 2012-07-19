Feature: Signing in
  In order to protect my data and to only see my data
  As a visitor
  I want to sign in

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "bart@thesimpsons.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Bart", last_name: "Simpson"

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
     Then I should be on the home page
      And I should see "Einloggen"

  Scenario: User with two employees signing in successfully
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an employee exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Bart", last_name: "Simpson"

    Given I am on the home page
     When I follow "Einloggen"
      And I fill in "E-Mail" with "bart@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on the dashboard page
      And I should be signed in as "bart@thesimpsons.com"
