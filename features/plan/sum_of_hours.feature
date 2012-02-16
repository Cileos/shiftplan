Feature: Sum of hours in plan
  In order for my employees to work enough according to their contract
  As a Planer
  I want to see the sum of their planned working ours in the week view

  Background:
    Given a planner exists
      And an organization exists with planner: the planner
      And a plan exists with organization: the organization, first_day: "2011-02-07"
      And I am signed in as the planner

  Scenario: nothing planned
    Given an employee exists with first_name: "Homer", last_name: "Simpson", organization: the organization
    # And I did not plan any schedules for him
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden |
        | Homer Simpson | 0       |

  Scenario: work 9 to 5 every weekday
    Given an employee exists with first_name: "Homer", last_name: "Simpson", organization: the organization
      And the employee was scheduled in the plan as following:
        | day | quickie |
        | 1   | 9-17    |
        | 2   | 9-17    |
        | 3   | 9-17    |
        | 4   | 9-17    |
        | 5   | 9-17    |
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden |
        | Homer Simpson | 40      |

   @javascript
   Scenario: yeah Peter, whats happening? I'll need you go ahead and come in on saturday and sunday as well
    Given an employee exists with first_name: "Peter", last_name: "Gibbons", organization: the organization
      And the employee was scheduled in the plan as following:
        | day | quickie |
        | 1   | 9-17    |
        | 2   | 9-17    |
        | 3   | 9-17    |
        | 4   | 9-17    |
        | 5   | 9-17    |
      And I am on the page of the plan
     When I schedule "Peter Gibbons" on "Samstag" for "10-17"
      And I schedule "Peter Gibbons" on "Sonntag" for "12-17"
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden |
        | Peter Gibbons | 52      |

