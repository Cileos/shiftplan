# remove wip tag and add new account link, when we are able to support multiple
# accounts/billing
@wip
Feature: Create Account
  In order to have more than one account
  As a user
  I want to create accounts

  Scenario: Create account
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a confirmed user "bart" exists with email: "bart@thesimpsons.com"
      And an employee "bart" exists with first_name: "Bart", account: the account "tepco", user: the confirmed user "bart"
      And the employee "bart" is a member of the organization "fukushima"
      And I am signed in as the confirmed user "bart"

    Given a clear email queue
     When I go to the dashboard
      And I follow "Account hinzufügen"
      # prefill with first employee of user
     Then the "Vorname" field should contain "Bart"
      And the "Nachname" field should contain "Simpson"
      And I fill in the following:
        | Accountbezeichnung  | 1. FC Springfield e.V. |
        | Organisationsname   | Skateboard             |
      And I press "Anlegen"

     Then an account "springfield" should exist with name: "1. FC Springfield e.V."
      And an organization "skateboard" should exist with name: "Skateboard", account: the account "springfield"
      And 1 users should exist with email: "bart@thesimpsons.com"
      And an employee "bart 2" should exist with first_name: "Bart", account: the account "springfield", role: "owner", user: the confirmed user "bart"
      And a membership should exist with employee: employee "bart 2", organization: organization "skateboard"
      And "bart@thesimpsons.com" should receive no email
      And I should be on the page of the account "springfield"
