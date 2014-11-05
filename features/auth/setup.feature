@javascript
Feature: Setup / First UX
  In order to have a nice first time User Experience
  Without causing to much confusion
  And to have the neccessary records to plan upon
  As a user who just signed up and confirmed
  I want to be guided to a wizard choosing the shape of my shiftplan


  Background:
    Given a confirmed user exists with email: "me@example.com"
      And an empty setup exists with user: the user
      # goal: be on page of plan
      And 0 plans should exist
      And I am signed in as the user
     When I go to the dashboard
     Then I should be on the setup page
      And I should not see "Zurück"



  Scenario: big company with boss knowing names for everything
    Given I should see "Unter welchem Namen möchtest Du für die anderen Mitarbeiter sichtbar sein?"
     When I fill in "Vorname" with "Montgomery"
      And I fill in "Nachname" with "Burns"
      And I press "Weiter"

    Given I should see "Was ist der Name Deiner Firma oder Institution?"
      And the "Accountbezeichnung" field should be empty
      And the placeholder for field "Accountbezeichnung" should be "Meine Firma"
     When I fill in "Accountbezeichnung" with "Powerplant"
      And I press "Weiter"

    Given I should see "In welcher Zeitzone findet der Großteil der Arbeit statt?"
     When I select "GMT-10:00 Hawaii" from "Zeitzone"
      And I press "Weiter"

    Given I should see "Bei größeren Firmen macht es Sinn, Pläne und Mitarbeiter in Organisationeinheiten wie zB Filialen, Häuser oder Standorte zu unterteilen."
      And I should see "Mit welcher Organisationseinheit möchtest Du Deine Planung für Mitarbeiter beginnen?"
     When I fill in "Erster Organisationsname" with "Reaktor"
    Given I should see "Unterteilst Du diese Organisation weiter in Arbeitsbereiche oder -Gruppen?"
     When I fill in "Gruppen" with "Brennstäbe wechseln, Knöpfe drücken, Room-Service"
      And I press "Weiter"

     Then I should see "Sind diese Informationen korrekt?"
      And I should see "jederzeit änderbar"
      But I should not see "Weiter"

     When I press "Zurück"
     Then the "Gruppen" field should contain "Brennstäbe wechseln, Knöpfe drücken, Room-Service"
     When I press "Weiter"
     Then I should see "Montgomery"
      And I should see "Burns"
      And I should see "Powerplant"
      And I should see "Reaktor"
      And I should see "Hawaii"
      # defaults/placeholders are not shown
      But I should not see "Meine Firma"
      And I press "Zahlungspflichtig erstellen"

     Then a plan should exist
      And I should be on the employees in week page of the plan for today

      And an account should exist with name: "Powerplant", time_zone_name: "Hawaii"

     When I choose "Mitarbeiter anlegen" from the drop down "Weitere Aktionen"
     Then I should see the following table of employees:
       | Name              | Status |
       | Burns, Montgomery | Aktiv  |

     When I go to the dashboard
     # setup was disabled/destroyed
     Then I should be on the dashboard

     Then "marketing@clockwork.io" should receive an email with subject "Account was set up: me@example.com"

  Scenario: small company with boss having to imagination
     # try to go really fast. But we need at least the username
     When I press "Weiter"
      And I press "Weiter"
     Then I should see error "muss ausgefüllt werden"
     When I fill in "Vorname" with "Homer"
      And I fill in "Nachname" with "Simpson"
      And I press "Weiter"
      # no account name
      And I press "Weiter"
      # time zone is auto detected (fingers crossed)
      And I press "Weiter"
      # no organization name or teams
      And I press "Weiter"
      # summary showing defaults being used to create account&org
     Then I should see "Homer"
      And I should see "Simpson"
      And I should see "Meine Firma"
      And I should see "Meine Organisation"
      And I press "Zahlungspflichtig erstellen"
     Then a plan should exist
      And I should be on the employees in week page of the plan for today
      And I should see "Meine Firma" within the orientation bar
      And I should see "Meine Organisation" within the orientation bar
      # hidden default
      And I should see "Mein erster Plan"
