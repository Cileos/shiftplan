Feature: Sum of hours in plan
  In order for my employees to work enough according to their contract
  As a Planer
  I want to see the sum of their planned working ours in the week view

  Background:
    Given today is 2011-02-07
      And the situation of a nuclear reactor

  Scenario: nothing planned
    # I did not plan any schedules for Homer
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden/WAZ |
        | Planner Burns | 0           |
        | Carl C        | 0           |
        | Lenny L       | 0           |
        | Homer S       | 0 von 40    |

  Scenario: work 9 to 5 every weekday
    Given the employee "Homer" was scheduled in the plan as following:
        | cwday | quickie |
        | 1     | 9-17    |
        | 2     | 9-17    |
        | 3     | 9-17    |
        | 4     | 9-17    |
        | 5     | 9-17    |
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden/WAZ |
        | Planner Burns | 0           |
        | Carl C        | 0           |
        | Lenny L       | 0           |
        | Homer S       | 40 von 40   |

   @javascript
   Scenario: yeah Homer, whats happening? I'll need you go ahead and come in on saturday and sunday as well
    Given the employee "Homer" was scheduled in the plan as following:
        | cwday | quickie |
        | 1     | 9-17    |
        | 2     | 9-17    |
        | 3     | 9-17    |
        | 4     | 9-17    |
        | 5     | 9-17    |
      And I am on the page of the plan
     When I schedule "Homer S" on "Sa" for "10-17"
      And I schedule "Homer S" on "So" for "12-17"
     Then I should see the following calendar:
        | Mitarbeiter   | Stunden/WAZ |
        | Planner Burns | 0           |
        | Carl C        | 0           |
        | Lenny L       | 0           |
        | Homer S       | 52 von 40   |

