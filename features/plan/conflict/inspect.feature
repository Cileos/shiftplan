@javascript
Feature: Inspect conflicts on Schedulings
  As a planner
  In order to avoid to have to clone my employees
  I want to see an indication when an employee is scheduled twice at the same time
  And I want to click on that indication to see the conflicting scheduling(s)

  Scenario: Find a red exclamation mark, see provoker and established schedulings
    Given today is 2012-02-13
      And the situation of a nuclear reactor
      And a plan "feed dogs" exists with organization: organization "Reactor", name: "Feed the hungry Dogs"
      And the employee "Homer" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2012-02-15 | 10-18   |
      And the employee "Homer" was scheduled in the plan "feed dogs" as following:
        | date       | quickie  |
        | 2012-02-15 | 13:15-14 |
        | 2012-02-15 | 15:15-16 |

     When I go to the teams in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Teams     | Mo | Di | Mi                    | Do | Fr | Sa | So |
        | Ohne Team |    |    | Homer S 10:00-18:00 ! |    |    |    |    |

     When I go to the employees in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Mitarbeiter      | Mo | Di | Mi            | Do | Fr | Sa | So |
        | Planner Burns    |    |    |               |    |    |    |    |
        | Carl C           |    |    |               |    |    |    |    |
        | Lenny L          |    |    |               |    |    |    |    |
        | Homer S          |    |    | 10:00-18:00 ! |    |    |    |    |
        | Ohne Mitarbeiter |    |    |               |    |    |    |    |

     When I follow "!" within the cell "Mi"/"Homer S"
      And I wait for the modal box to appear
     Then I should see "10:00-18:00" within the left column within the modal box
      And I should see "13:15-14:00" within the right column within the modal box
      And I should see "15:15-16:00" within the right column within the modal box


