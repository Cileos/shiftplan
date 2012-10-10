@javascript
Feature: View as employees in week (first one)

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: move a scheduling from one employee to the other
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 1     | 9-17    |
      And I am on the page of the plan
     Then I should be on the employees in week page for the plan for year: 2012, week: 49
      And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "0"
     When I click on scheduling "9-17"
      And I change the "Quickie" from "9-17" to "9-17" and select "Lenny L" as "Mitarbeiter"
     Then I should be on the employees in week page for the plan for year: 2012, week: 49
      And I should see the following calendar:
        | Mitarbeiter   | Mo   | Di | Mi | Do | Fr | Sa | So |
        | Carl C        |      |    |    |    |    |    |    |
        | Lenny L       | 9-17 |    |    |    |    |    |    |
        | Homer S       |      |    |    |    |    |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "8"


  Scenario: Navigating back and forth weekwise
    Given I am on the employees in week page of the plan for year: 2012, week: 49
      When I follow ">" within the calendar navigation
      Then I should be on the employees in week page of the plan for year: 2012, week: 50
      When I follow "Heute" within the calendar navigation
      Then I should be on the employees in week page of the plan for year: 2012, week: 49
      When I follow "<" within the calendar navigation
      Then I should be on the employees in week page of the plan for year: 2012, week: 48

  # a basic version of this is tested in every plan/view_*week.feature
  Scenario: Navigation weekly back and forth
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 48   | 1     | 9-17    |
        | 49   | 2     | 10-16   |
        | 50   | 3     | 11-15   |
        | 51   | 4     | 12-14   |

     When I go to the page of the plan
     Then I should be on the employees in week page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di    | Mi | Do | Fr |
        | Carl C        |    |       |    |    |    |
        | Lenny L       |    |       |    |    |    |
        | Homer S       |    | 10-16 |    |    |    |

     When I follow "<" within the calendar navigation
     Then I should be on the employees in week page of the plan for week: 48, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 48 26.11.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo   | Di | Mi | Do | Fr |
        | Carl C        |      |    |    |    |    |
        | Lenny L       |      |    |    |    |    |
        | Homer S       | 9-17 |    |    |    |    |

     When I follow ">" within the calendar navigation
     Then I should be on the employees in week page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di    | Mi | Do | Fr |
        | Carl C        |    |       |    |    |    |
        | Lenny L       |    |       |    |    |    |
        | Homer S       |    | 10-16 |    |    |    |

     When I follow ">" within the calendar navigation
     Then I should be on the employees in week page of the plan for week: 50, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi    | Do | Fr |
        | Carl C        |    |    |       |    |    |
        | Lenny L       |    |    |       |    |    |
        | Homer S       |    |    | 11-15 |    |    |

     When I follow ">" within the calendar navigation
     Then I should be on the employees in week page of the plan for week: 51, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 51 17.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do    | Fr |
        | Carl C        |    |    |    |       |    |
        | Lenny L       |    |    |    |       |    |
        | Homer S       |    |    |    | 12-14 |    |
