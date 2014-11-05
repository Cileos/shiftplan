@javascript
Feature: Create Account
  In order to have more than one account
  As a user
  I want to create accounts

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And the employee "bart" is a member of the organization
      And I am signed in as the user "bart"

  Scenario: Create account
    Given a clear email queue
      And I am on the dashboard
     When I choose "Alle Organisationen" from the drop down "Organisationen"
      And I follow "Account hinzufügen"
     Then I should be on the setup page

      #########################
      # Setup opens
      #########################

      # prefill with first employee of user
    Given the "Vorname" field should contain "Bart"
      And the "Nachname" field should contain "Simpson"
     When I press "Weiter"
      And I fill in "Accountbezeichnung" with "Boogers Inc."
      And I press "Weiter"
      # skip timezone
      And I press "Weiter"
      And I fill in "Erster Organisationsname" with "Skinner's Nightmare"
      And I fill in "Gruppen" with "Pranks in School, Prank Calls, Detention"
      And I press "Weiter"

     Then I should see "neues Vertragsverhältnis"
      And I should see "kostenpflichtiges Paket"

     When I press "Zahlungspflichtig erstellen"

     Then an account "new" should exist with name: "Boogers Inc."
      And an organization "new" should exist with name: "Skinner's Nightmare", account: the account "new"
      And an employee "bart 2" should exist with first_name: "Bart", account: the account "new", user: the confirmed user "bart"
      And the employee "bart 2" should be a member in the organization "new"

      And a plan "new" should exist with organization: the organization "new"
      And I should be on the employees in week page of the plan "new" for today

      And "bart@thesimpsons.com" should receive no email
