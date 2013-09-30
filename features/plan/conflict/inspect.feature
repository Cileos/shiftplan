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

     When I go to the employees in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Mitarbeiter      | Mi            |
        | Planner Burns    |               |
        | Carl C           |               |
        | Lenny L          |               |
        | Homer S          | 10:00-18:00 ! |
        | Ohne Mitarbeiter |               |

     When I go to the teams in week page of the plan "clean reactor" for cwyear: 2012, week: 7
     Then I should see the following calendar:
        | Teams     | Mi                    |
        | Ohne Team | Homer S 10:00-18:00 ! |

     When I follow "!" within the cell "Mi"/"Ohne Team"
      And I wait for the modal box to appear
     Then I should see "10:00-18:00" within the left column within the modal box
      And I should see "13:15-14:00" within the right column within the modal box
      And I should see "15:15-16:00" within the right column within the modal box


     When I close the modal box
      And I click on the scheduling "10:00-18:00"
      And I select "Lenny L" from "Mitarbeiter"
      And I press "Speichern"
      And I wait for the modal box to disappear
     # other employee => conflict gone
     Then I should see the following calendar:
        | Teams     | Mi                  |
        | Ohne Team | Lenny L 10:00-18:00 |

     When I click on the scheduling "10:00-18:00"
      And I select "Homer S" from "Mitarbeiter"
      And I press "Speichern"
      And I wait for the modal box to disappear
     # back to previous employee => conflict reappears
     Then I should see the following calendar:
        | Teams     | Mi                    |
        | Ohne Team | Homer S 10:00-18:00 ! |
