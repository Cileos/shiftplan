Feature: Dashboard
  As an employee
  I want to see all my organizations with their plans on the dashboard page
  In order to be able to choose from one of them

  Scenario: Dashboard page with multiple organizations
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.de"
      And an account exists
      # week 49
      And today is 2012-12-04

      And the situation of an atomic power plant tschernobyl

      And an organization "fukushima" exists with name: "AKW Fukushima GmbH", account: the account
      And the employee "Homer" is a member of the organization "fukushima"
      And a plan "reaktor putzen" exists with organization: organization "fukushima", name: "Reaktor putzen in Fukushima"

     And I am signed in as the user "homer"
    When I go to the dashboard
     And I should see "AKW Fukushima GmbH"
     And I should see "Reaktor putzen in Fukushima"
     And I should see "AKW Tschernobyl GmbH"
     And I should see "Brennstäbe wechseln in Tschernobyl"

    When I follow "Reaktor putzen in Fukushima"
    Then I should be on the employees in week page of the plan "reaktor putzen" for week: 49, year: 2012

    Then I go to the dashboard
    When I follow "Brennstäbe wechseln in Tschernobyl"
    Then I should be on the employees in week page of the plan "brennstäbe wechseln" for week: 49, year: 2012

