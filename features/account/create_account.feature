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
     When I go to the dashboard
      And I follow "Account hinzufügen"
      # prefill with first employee of user
     Then the "Vorname" field should contain "Bart"
      And the "Nachname" field should contain "Simpson"
      And I should see "neues Vertragsverhältnis"
      And I should see "kostenpflichtiges Paket"
     When I fill in the following:
        | Accountbezeichnung | FC Springfield e.V. |
        | Organisationsname  | Skateboard          |
      And I press "Anlegen"
     Then I should see a flash notice "Account erfolgreich angelegt."

     Then an account "fc" should exist with name: "FC Springfield e.V."
      And an organization "skateboard" should exist with name: "Skateboard", account: the account "fc"
      And an employee "bart 2" should exist with first_name: "Bart", account: the account "fc", role: "owner", user: the confirmed user "bart"
      And the employee "bart 2" should be a member in the organization "skateboard"
      And "bart@thesimpsons.com" should receive no email
      # TODO run the setup, resulting in a plan?
      #And I should be on the page of the account "fc"
