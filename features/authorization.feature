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
    Given a confirmed user "employee" exists
      And an employee "employee" exists with user: the confirmed user "employee", first_name: "Homer", account: the account
      And the employee "employee" is a member in the organization
      And an employee "bart" exists with first_name: "Bart", account: the account
      And the employee "bart" is a member in the organization
      And I am signed in as the confirmed user "employee"

     When I go to the dashboard page
     Then I should be authorized to access the page
      And I should see link "Ausloggen" within the user navigation
      But I should not see link "Einloggen"

     When I follow "Fukushima"
      And I choose "Alle Pläne" from the drop down "Pläne"
     Then I should be authorized to access the page
      But I should not see link "Hinzufügen"
      And I should see link "Ausloggen" within the user navigation
      And I should see link "Fukushima" within the navigation
      And I should see link "Pläne" within the navigation
      And I should see link "Mitarbeiter" within the navigation
      And I should see link "Teams" within the navigation

     When I follow "Brennstäbe wechseln"
     Then I should be authorized to access the page
      But I should not see link "Neue Terminierung"
      And I should not see link "Übernahme aus der letzten Woche"

     When I follow "Mitarbeiter"
     Then I should be authorized to access the page
      And I should see "Simpson, Bart"
      But I should not see link "Simpson, Homer"
      And I should not see link "Simpson, Bart"
      And I should not see link "Hinzufügen"
      And I should not see link "Einladen"
      But I should see "Noch nicht eingeladen"

     When I follow "Teams"
     Then I should be authorized to access the page
      And I should see "Kühlwasser tauschen"
      And I should not see link "Bearbeiten"
      And I should not see link "Hinzufügen"
      And I should not see button "Zusammenlegen"

  Scenario: planner
    Given a confirmed user "planner" exists
      And an employee planner exists with user: the confirmed user "planner", account: the account
      And I am signed in as the confirmed user "planner"

      And the situation of what a planner can do

  Scenario: owner
      Given I am signed in as the confirmed user "mr. burns"

    # an owner can do everything a planner can do and maybe more some time
      Then the situation of what a planner can do
