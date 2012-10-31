Feature: create organizations
  As a planer of an organization with too much chaos
  In order to optimize my plans
  I want to create another organization belonging to the same account

  Background:
    Given the situation of a just registered user

  Scenario: creating another organization
    Given I am on the dashboard page
      And I follow "eine weitere Organisation anlegen"
      And I fill in "Name" with "Reactor Shelbyville"
      And I press "Anlegen"

     Then I should be on the dashboard
      And I should see "Organisation 'Reactor Shelbyville' angelegt."
      And I should see "Fukushima" within the content
      And I should see "Reactor Shelbyville" within the content
      And an organization "shelbyville" should exist with name: "Reactor Shelbyville", account: the account
      And a blog "shelbyville" should exist with organization: the organization "shelbyville"

     When I follow "Reactor Shelbyville"
      And I follow "Neuigkeiten"
     Then I should see "Es wurden noch keine Blogposts erstellt."
