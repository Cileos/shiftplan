Feature: Dashboard
  As an employee
  I want to see all my organizations with their plans on the dashboard page
  In order to be able to choose from one of them

  Background:
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.de"
      And an account exists
      # week 49
      And today is 2012-12-04
      And the situation of an atomic power plant tschernobyl

  Scenario: Dashboard page with multiple organizations
    Given an organization "fukushima" exists with name: "AKW Fukushima GmbH", account: the account
      And the employee "Homer" is a member of the organization "fukushima"
      And a plan "reaktor putzen" exists with organization: organization "fukushima", name: "Reaktor putzen in Fukushima"


     And I am signed in as the user "homer"
    When I go to the dashboard

     And I should see "Organisationen" within the navigation
     And I should see "AKW Fukushima GmbH" within the organization dropdown list
     And I should see "AKW Tschernobyl GmbH" within the organization dropdown list

    When I go to the dashboard
     And I follow "AKW Fukushima GmbH"
     Then I should be on the page for the organization "fukushima"

  Scenario: Lists recent notifications
    Given a notification exists with employee: the employee "Homer"
      And I am signed in as the user "homer"
     When I go to the dashboard
     # full introductory_text of dummy notification
     Then I should see "You did something awesome"
