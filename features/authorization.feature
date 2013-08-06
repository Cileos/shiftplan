Feature: Authorization
  In order to protect my data from sabotage or accidents
  As a owner
  I want only authorized users to access the page

  # please try to visit pages by jumping to them, interconnectivity should be
  # considered in other features

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a plan exists with name: "Brennstäbe wechseln", organization: the organization
      And a team "kühlwasser wechseln" exists with name: "Kühlwasser wechseln", organization: the organization
      And another team "kühlwasser tauschen" exists with name: "Kühlwasser tauschen", organization: the organization


  Scenario: anonymous user
     When I go to the home page
     Then I should be authorized to access the page
      And I should see link "Einloggen" within the user navigation
      But I should not see link "Dashboard"
      But I should not see link "Profil"
      But I should not see link "Mitarbeiter"

     When I go to the signin page
     Then I should be authorized to access the page
      And I should see link "Einloggen" within the user navigation
      But I should not see link "Ausloggen"

     When I go to the dashboard
     Then I should be on the signin page

     When I go to the page of the plan
     Then I should be on the signin page

  Scenario: employee
    Given a confirmed user "homer" exists
      And an employee "homer" exists with user: the confirmed user "homer", first_name: "homer", account: the account
      And the employee "homer" is a member in the organization "sector 7g"
      And another organization "cooling towers" exists with name: "Cooling Towers", account: the account
      And I am signed in as the confirmed user "homer"

     When I go to the dashboard page
     Then I should be authorized to access the page

      And the user should have the abilities of an employee in the organization "sector 7g"
      # not a member of "Cooling Towers"
      But I should not see link "Cooling Towers" within the navigation


  Scenario: planner
    Given a confirmed user "homer" exists
      And an employee "homer" exists with user: confirmed user "homer", account: the account
      And the employee "homer" is a planner of the organization "sector 7g"
      And another organization "cooling towers" exists with name: "Cooling Towers", account: the account
      And the employee "homer" is a member of the organization "cooling towers"
      And a plan exists with name: "Frühjahrsputz", organization: the organization "cooling towers"
      And I am signed in as the confirmed user "homer"

     Then the user should have the abilities of a planner in the organization "sector 7g"
      # Homer is only a normal member/employee of "Cooling Towers". So he acts
      # like an employee here.
      And the user should have the abilities of an employee in the organization "cooling towers"
      But the user should not have the ability to crud the account or organizations

  Scenario: owner
      Given another organization "cooling towers" exists with name: "Cooling Towers", account: the account
        And a plan exists with name: "Wasser", organization: the organization "cooling towers"
        And a team exists with name: "Kühlwasser nachfüllen", organization: the organization "cooling towers"
        And another team exists with name: "Kühlwasser filtern", organization: the organization "cooling towers"

       When I am signed in as the user "mr burns"
        And I go to the dashboard page

       Then the user should have the ability to crud the account or organizations
        And the user should have the abilities of a planner in the organization "sector 7g"
       # For the organization "Cooling Towers" Mr Burns does not even have a
       # membership. But as he is the owner of the account, he is allowed to
       # do everything there, too.
        And the user should have the abilities of a planner in the organization "cooling towers"
