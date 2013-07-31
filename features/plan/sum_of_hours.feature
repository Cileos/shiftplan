Feature: Sum of hours in plan
  In order for my employees to work enough according to their contract
  As a Planer
  I want to see the sum of their planned working ours in the week view

  Background:

   @javascript
   Scenario: yeah Homer, whats happening? I'll need you go ahead and come in on saturday and sunday as well
    Given the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie |
        | 2012 | 6    | 1     | 9-17    |
        | 2012 | 6    | 2     | 9-17    |
        | 2012 | 6    | 3     | 9-17    |
        | 2012 | 6    | 4     | 9-17    |
        | 2012 | 6    | 5     | 9-17    |
    # Homer had his full 12-annual holiday in week 5. Missed a lot of work
     When I go to the employees in week page for the plan for cwyear: 2012, week: 5
     Then I should see the following WAZ:
        | Carl C        | 0      |
        | Lenny L       | 0      |
        | Homer S       | 0 / 40 |

     When I go to the employees in week page for the plan for cwyear: 2012, week: 6
     Then I should see the following WAZ:
        | Carl C        | 0       |
        | Lenny L       | 0       |
        | Homer S       | 40 / 40 |

     When the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie |
        | 2012 | 6    | 6     | 10-17    |
        | 2012 | 6    | 7     | 12-17    |
      And the employee "Carl" was scheduled in the plan as following:
        | year | week | cwday | quickie  |
        | 2012 | 6    | 1     | 12-12:30 |
        | 2012 | 6    | 2     | 12-13:45 |

      And an organization "Private" exists with name: "Private", account: the account
      And a plan "Lunch" exists with organization: organization "Private"
      And the employee "Homer" is a member in the organization "Private"
      And the employee "Homer" was scheduled in the plan "Lunch" as following:
        | year | week | cwday | quickie  |
        | 2012 | 6    | 1     | 12-12:30 |
        | 2012 | 6    | 2     | 12-13:00 |

      And I go to the employees in week page for the plan for cwyear: 2012, week: 6
     Then I should see the following WAZ:
        | Carl C  | 2¼            |
        | Lenny L | 0             |
        | Homer S | 52 (+1½) / 40 |
