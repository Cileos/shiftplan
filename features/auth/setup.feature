@javascript
Feature: Setup / First UX
  In order to have a nice first time User Experience
  Without causing to much confusion
  And to have the neccessary records to plan upon
  As a user who just signed up and confirmed
  I want to be guided to a wizard choosing the shape of my shiftplan


  Background:
    Given a confirmed user exists
      And a setup exists with user: the user
      And I am signed in as the user
     When I go to the dashboard
     Then I should be on the setup page



  Scenario: big company with boss knowing names for everything
    Given I should see "Unter welchem Namen möchtest Du für die anderen Mitarbeiter sichtbar sein?"
     When I fill in "Vorname" with "Montgomery"
      And I fill in "Nachname" with "Burns"
      And I press "Weiter"

    Given I should see "Was ist der Name Deiner Firma oder Institution?"
     When I fill in "Accountname" with "Powerplant"
      And I press "Weiter"

    Given I should see "Bei größeren Firmen macht es Sinn, Pläne und Mitarbeiter in Organisationeinheiten wie zB Filialen, Häuser oder Standorte zu unterteilen."
      And I should see "Mit welcher Organisationseinheit möchtest Du Deine Planung für Mitarbeiter beginnen?"
     When I fill in "Organisationsname" with "Reaktor"
    Given I should see "Unterteilst Du diese Organisation weiter in Arbeitsbereiche oder -Gruppen"
     When I fill in "Teamnamen" with "Brennstäbe wechseln, Knöpfe drücken"
      And I press "Weiter"

     Then I should see "Sind diese Daten korrekt?"
      And I should see "jederzeit änderbar"
     When I press "Fertig"

     Then an account should exist with owner: the user, name: "Powerplant"
      And an organization should exist with account: the account, name: "Reaktor"
      And a team should exist with organization: the organization, name: "Brennstäbe wechseln"
      And a team should exist with organization: the organization, name: "Knöpfe drücken"
      And an employee should exist with first_name: "Montgomery", last_name: "Burns", account: the account
      And the employee should be member in the organization
      And the employee should be the account's owner
      And a plan should exist with organization: the organization

      And I should be on the page of the plan
      And I should see link "Mitarbeiter hinzufügen"

