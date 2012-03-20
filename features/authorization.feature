Feature: Authorization
  In order to protect my data from sabotage or accidents
  As a planner
  I want only authorized users to access the page

  # please try to visit pages by jumping to them, interconnectivity should be
  # considered in other features

  Background:
    Given an organization exists with name: "Fukushima GmbH"
      And a confirmed user exists
      And a planner exists with user: the confirmed user, organization: the organization
      And a plan exists with organization: the organization


  Scenario: anonymous user
     When I go to the home page
     Then I should be authorized to access the page
      And I should see link "Einloggen" within the navigation
      But I should not see link "Dashboard"
      But I should not see link "Profil"
      But I should not see link "Mitarbeiter"

     When I go to the signin page
     Then I should be authorized to access the page
      And I should see link "Einloggen" within the navigation
      But I should not see link "Ausloggen"

     When I go to the dashboard
     Then I should not be authorized to access the page

     When I go to the page of the plan
     Then I should not be authorized to access the page

  Scenario: planner
    Given I am signed in as the confirmed user

     When I go to the home page
     Then I should be authorized to access the page
      And I should see link "Ausloggen" within the navigation
      And I should see link "Dashboard" within the navigation
      But I should not see link "Einloggen"

     When I go to the dashboard
     Then I should be authorized to access the page
      And I should see link "Ausloggen" within the navigation
      And I should see link "Dashboard" within the navigation
     When I follow "Fukushima GmbH"
      And I should see link "Hinzufügen"

     When I go to the page of the plan
     Then I should be authorized to access the page
      And I should see link "Neue Terminierung"
