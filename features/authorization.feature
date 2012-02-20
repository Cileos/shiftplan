Feature: Authorization
  In order to protect my data from sabotage or accidents
  As a planner
  I want only authorized users to access the page

  # please try to visit pages by jumping to them, interconnectivity should be
  # considered in other features

  Background:
    Given a planner exists
      And an organization exists with planner: the planner
      And a plan exists with organization: the organization
      And a employee exists with first_name: "Milton", organization: the organization, last_name: "G"


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
    Given I am signed in as the planner

     When I go to the home page
     Then I should be authorized to access the page
      And I should see link "Ausloggen" within the navigation
      And I should see link "Dashboard" within the navigation
      But I should not see link "Einloggen"

     When I go to the dashboard
     Then I should be authorized to access the page
      And I should see link "Ausloggen" within the navigation
      And I should see link "Dashboard" within the navigation
      #  And I should see link "Mitarbeiter" within the navigation
      And I should see link "neuer Plan"

     When I go to the page of the plan
     Then I should be authorized to access the page
      And I should see link "Neue Terminierung"
