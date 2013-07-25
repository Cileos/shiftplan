Feature: Authorization
  In order to protect my data from sabotage or accidents
  As a owner
  I want only authorized users to access the page

  # please try to visit pages by jumping to them, interconnectivity should be
  # considered in other features

  Background:
    Given the situation of a just registered user
      And I sign out
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
    Given a confirmed user "bart" exists
      And an employee "bart" exists with user: the confirmed user "bart", first_name: "Bart", account: the account
      And the employee "bart" is a member in the organization
      And another organization "tschernobyl" exists with name: "Tschernobyl", account: the account
      And I am signed in as the confirmed user "bart"

     When I go to the dashboard page
     Then I should be authorized to access the page

      # not a member of Tschernobyl
      And I should not see link "Tschernobyl" within the navigation

     When I follow "Fukushima"
      And I choose "Alle Pläne" from the drop down "Pläne"
     Then I should be authorized to access the page
      But I should not see link "Hinzufügen"
      And I should see link "Fukushima" within the navigation
      And I should see link "Pläne" within the navigation
      And I should not see link "Mitarbeiter" within the navigation
      And I should not see link "Teams" within the navigation

     When I follow "Brennstäbe wechseln"
     Then I should be authorized to access the page
      But I should not see link "Neue Terminierung"
      And I should not see link "Übernahme aus der letzten Woche"
      And I should not see link "Planvorlage anwenden"

  Scenario: planner
    Given a confirmed user "bart" exists
      And an employee "bart" exists with user: the confirmed user "bart", account: the account
      And a membership exists with role: "planner", organization: the organization "fukushima", employee: the employee "bart"
      And another organization "tschernobyl" exists with name: "Tschernobyl", account: the account
      And a membership exists with organization: the organization "tschernobyl", employee: the employee "bart"
      And a plan exists with name: "Frühjahrsputz", organization: the organization "tschernobyl"
      And I am signed in as the confirmed user "bart"

      And the situation of what a planner can do

      # only normal member/employee of Tschernobyl. so acts like an employee
      # here
     When I follow "Tschernobyl"
     Then I should see link "Pläne" within the navigation
     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should be authorized to access the page
      But I should not see link "Hinzufügen"

      And I should not see link "Mitarbeiter" within the navigation
      And I should not see link "Teams" within the navigation
      And I should not see link "Qualifikationen" within the navigation
      And I should not see link "Planvorlagen" within the navigation

     When I follow "Frühjahrsputz"
     Then I should be authorized to access the page
      But I should not see link "Neue Terminierung"
      And I should not see link "Übernahme aus der letzten Woche"
      And I should not see link "Planvorlage anwenden"

  Scenario: owner
      Given I am signed in as the confirmed user "mr. burns"
        And another organization "tschernobyl" exists with name: "Tschernobyl", account: the account
        And a plan exists with name: "Wasser", organization: the organization "tschernobyl"
        And a team exists with name: "Kühlwasser nachfüllen", organization: the organization "tschernobyl"
        And another team exists with name: "Kühlwasser filtern", organization: the organization "tschernobyl"

        And the situation of what a planner can do

       # For the organization Tschernobyl the employee does not even have a
       # membership. But as he is the owner of the account, he is allowed to
       # do everything there, too.
       When I follow "Tschernobyl"
       Then I should be authorized to access the page
        And I choose "Alle Pläne" from the drop down "Pläne"
       Then I should be authorized to access the page
        And I should see link "Hinzufügen"
        And I should see link "Pläne" within the navigation
        And I should see link "Mitarbeiter" within the navigation
        And I should see link "Teams" within the navigation

       When I follow "Wasser"
       Then I should be authorized to access the page
        And I should see link "Neue Terminierung"
        And I should see link "Übernahme aus der letzten Woche"
        And I should see link "Planvorlage anwenden"

       When I follow "Mitarbeiter"
       Then I should be authorized to access the page
        And I should see link "Hinzufügen"

       When I follow "Teams"
       Then I should be authorized to access the page
        And I should see link "Hinzufügen"
        And I should see link "Bearbeiten"
        And I should see button "Zusammenlegen"

       When I follow "Qualifikationen"
       Then I should be authorized to access the page
        And I should see link "Hinzufügen"

       When I follow "Planvorlagen"
       Then I should be authorized to access the page
        And I should see link "Hinzufügen"
