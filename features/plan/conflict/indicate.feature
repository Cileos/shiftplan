@javascript
Feature: Indicate conflicts on Schedulings
  As a planner
  In order to avoid to have to clone my employees
  I want to see an indication when an employee is scheduled twice at the same time

  Scenario: All hail to the red dot
    Given today is 2012-02-13
      And the situation of a nuclear reactor
      And a plan "feed dogs" exists with organization: organization "Reactor", name: "Feed the hungry Dogs"
      And the employee "Homer" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2012-02-15 | 10-18   |
      And the employee "Homer" was scheduled in the plan "feed dogs" as following:
        | date       | quickie  |
        | 2012-02-15 | 13:15-14 |

     When I go to the employees in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Mitarbeiter      | Mo | Di | Mi            | Do | Fr | Sa | So |
        | Planner Burns    |    |    |               |    |    |    |    |
        | Carl C           |    |    |               |    |    |    |    |
        | Lenny L          |    |    |               |    |    |    |    |
        | Homer S          |    |    | 10:00-18:00 ! |    |    |    |    |
        | Ohne Mitarbeiter |    |    |               |    |    |    |    |

     When I go to the teams in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Teams     | Mo | Di | Mi                    | Do | Fr | Sa | So |
        | Ohne Team |    |    | Homer S 10:00-18:00 ! |    |    |    |    |

