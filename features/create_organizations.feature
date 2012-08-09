Feature: create organizations
  As a planer of an organization with too much chaos
  In order to optimize my plans
  I want to create another organization belonging to the same account

  Background:
    Given an organization exists with name: "Reactor Springfield"
      And a confirmed user "Burns" exists with email: "burns@shiftplan.local"
      And an employee exists with organization: the organization, user: the confirmed user, role: "owner"
      # the account will be created on first visit of dashboard
      And 0 accounts should exist
      And I am signed in as the confirmed user "Burns"

  Scenario: creating another organization
     Given I am on the dashboard
      When I follow "eine weitere Organisation anlegen"
       And I fill in "Name" with "Reactor Shelbyville"
       And I press "Anlegen"
      Then I should be on the dashboard
       And I should see info "Organisation 'Reactor Shelbyville' angelegt."
       And I should see "Reactor Springfield" within the content
       And I should see "Reactor Shelbyville" within the content

       And an account should exist
       And an organization should exist with name: "Reactor Shelbyville"
       And the account should be the organization's account
       And the confirmed user should be the account's owner
