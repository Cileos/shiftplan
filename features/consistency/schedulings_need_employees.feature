Feature: Schedulings need employees
  In order to create schedulings
  As a planner
  I first have to register employees for my organisation

  Scenario: planner should not be able to create schedulings if no employees exist, yet
    Given a planner exists
      And an organization exists with planner: the planner
      And a plan exists with organization: the organization
      And I am signed in as the planner
      And I am on the page of the plan
     Then I should not see "Neue Terminierung"
