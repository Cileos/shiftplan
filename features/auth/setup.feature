@javascript
Feature: Setup / First UX
  In order to have a nice first time User Experience
  Without causing to much confusion
  And to have the neccessary records to plan upon
  As a user who just signed up and confirmed
  I want to be guided to a wizard choosing the shape of my shiftplan


  Background:
    Given a confirmed user exists
      And an empty setup exists with user: the user
      # goal: be on page of plan
      And 0 plans should exist
      And I am signed in as the user
     When I go to the dashboard
     Then I should be on the setup page
      And I should not see "Zurück"



  Scenario: big company with boss knowing names for everything
     # try to go really fast. But we need at least the username
     When I press "Weiter"
      And I press "Weiter"
     Then I should see error "muss ausgefüllt werden"

    Given I should see "Unter welchem Namen möchtest Du für die anderen Mitarbeiter sichtbar sein?"
     When I fill in "Vorname" with "Montgomery"
      And I fill in "Nachname" with "Burns"
      And I press "Weiter"

    Given I should see "Was ist der Name Deiner Firma oder Institution?"
      And the "Accountbezeichnung" field should be empty
     When I fill in "Accountbezeichnung" with "Powerplant"
      And I press "Weiter"

    Given I should see "Bei größeren Firmen macht es Sinn, Pläne und Mitarbeiter in Organisationeinheiten wie zB Filialen, Häuser oder Standorte zu unterteilen."
      And I should see "Mit welcher Organisationseinheit möchtest Du Deine Planung für Mitarbeiter beginnen?"
     When I fill in "Organisationsname" with "Reaktor"
    Given I should see "Unterteilst Du diese Organisation weiter in Arbeitsbereiche oder -Gruppen?"
     When I fill in "Gruppen" with "Brennstäbe wechseln, Knöpfe drücken"
      And I press "Weiter"

     Then I should see "Sind diese Informationen korrekt?"
      And I should see "jederzeit änderbar"
      But I should not see "Weiter"

     When I press "Zurück"
     Then the "Gruppen" field should contain "Brennstäbe wechseln, Knöpfe drücken"
     When I press "Weiter"
      And I press "Fertig"

     Then a plan should exist
      And I should be on the employees in week page of the plan for today

     When I choose "Mitarbeiter anlegen" from the drop down "Weitere Aktionen"
     Then I should see the following table of employees:
       | Name              | Status |
       | Burns, Montgomery | Aktiv  |

     When I go to the dashboard
     # setup was disabled/destroyed
     Then I should be on the dashboard

