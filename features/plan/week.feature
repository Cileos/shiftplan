Feature: Plan a week

  Background:
    Given a planner exists
      # week 49
      And today is 2012-12-04
      And an organization exists with planner: the planner
      And a plan exists with organization: the organization, name: "Dull Work"
      And a employee exists with first_name: "Jack", organization: the organization, last_name: "T"
      And I am signed in as the planner


  Scenario: Navigation weekly back and forth
    Given the employee was scheduled in the plan as following:
        | week | cwday | quickie |
        | 48   | 1     | 9-17    |
        | 49   | 2     | 10-16   |
        | 50   | 3     | 11-15   |
        | 51   | 4     | 12-14   |

     When I go to the page of the plan
     Then I should be on the page of the plan for week: 49
      And I should see a calendar titled "Dull Work - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag |
        | Jack T      |        | 10-16    |          |            |         |

     When I follow "<<" within the calendar navigation
     Then I should be on the page of the plan for week: 48, year: 2012
      And I should see a calendar titled "Dull Work - KW 48 26.11.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag |
        | Jack T      | 9-17   |          |          |            |         |
     
     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Dull Work - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag |
        | Jack T      |        | 10-16    |          |            |         |

     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 50, year: 2012
      And I should see a calendar titled "Dull Work - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag |
        | Jack T      |        |          | 11-15    |            |         |

     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 51, year: 2012
      And I should see a calendar titled "Dull Work - KW 51 17.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag |
        | Jack T      |        |          |          | 12-14      |         |
