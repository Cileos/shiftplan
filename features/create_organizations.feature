Feature: create organizations
  As a planer of an organization with too much chaos
  In order to optimize my plans
  I want to create another organization belonging to the same account

  Background:
    Given an account exists
      And an organization "Springfield" exists with name: "Reactor Springfield", account: the account
      And a confirmed user "Burns" exists with email: "burns@shiftplan.local"
      And an employee owner exists with user: the confirmed user, account: the account
      # we only deal with exactly one account
      And 1 accounts should exist
      And I am signed in as the confirmed user "Burns"

  Scenario: creating another organization
     Given I am on the dashboard
      When I follow "eine weitere Organisation anlegen"
       And I fill in "Name" with "Reactor Shelbyville"
       And I press "Anlegen"
      Then I should be on the dashboard
       And I should see notice "Organisation 'Reactor Shelbyville' angelegt."
       And an organization "Shelbyville" should exist with name: "Reactor Shelbyville"
       And the account should be the organization "Shelbyville"'s account
       And I should see "Reactor Springfield" within the navigation
       And I should see "Reactor Shelbyville" within the navigation
       And a blog "shelbyville" should exist with organization: the organization "shelbyville"
