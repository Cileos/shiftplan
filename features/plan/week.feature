@javascript
Feature: Plan a week

  Background:
    Given an organization exists
      And a confirmed user exists
      And an employee planner exists with first_name: "Jack", last_name: "T", user: the confirmed user, organization: the organization
      # week 49
      And today is 2012-12-04
      And a plan exists with organization: the organization, name: "Dull Work"
      And I am signed in as the confirmed user

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
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      |        | 10-16    |          |            |         | 6       |

     When I follow "<<" within the calendar navigation
     Then I should be on the page of the plan for week: 48, year: 2012
      And I should see a calendar titled "Dull Work - KW 48 26.11.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      | 9-17   |          |          |            |         | 8       |

     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Dull Work - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      |        | 10-16    |          |            |         | 6       |

     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 50, year: 2012
      And I should see a calendar titled "Dull Work - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      |        |          | 11-15    |            |         | 4       |

     When I follow ">>" within the calendar navigation
     Then I should be on the page of the plan for week: 51, year: 2012
      And I should see a calendar titled "Dull Work - KW 51 17.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      |        |          |          | 12-14      |         | 2       |

  # TODO do not copy schedulings of deactivated employee
  Scenario: copy from last week
    Given the employee was scheduled in the plan as following:
        | week | cwday | quickie |
        | 48   | 1     | 5-7     |
        | 49   | 2     | 10-11   |
        | 49   | 3     | 11-12   |
        | 49   | 4     | 12-13   |
      And I am on the page of the plan for week: 50
     When I follow "Übernahme aus der letzten Woche"
      And I wait for the modal box to appear
      And I select "KW 49 03.12.2012" from "Von"
      And I press "Übernehmen"
     Then I should be on the page of the plan for year: 2012, week: 50
      And I should see a calendar titled "Dull Work - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Stunden |
        | Jack T      |        | 10-11    | 11-12    | 12-13      |         | 3       |
