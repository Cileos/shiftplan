@javascript
Feature: Planning Active Unavailabilities
  As a planner/boss
  In order to remember when my employees are not able to work
  I want to maintain unavailability entries in a monthly calendar for each of them.

  Background:
    Given today is 2012-12-21
      And the situation of a nuclear reactor
      And I choose "Abwesenheit" from the drop down "Stammdaten"
     Then I should be on the availability page
      And I wait for Ember to boot

  Scenario: enter an education day for one of the employees
     When I select "Homer S" from "Mitarbeiter"
      And I wait for the spinner to stop
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |
     When I follow "21"
      And I wait for the modal box to appear
      And I select "Weiterbildung" from "Grund"
      And I uncheck "Ganztägig"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                          | Sa | So |
         |    |    |    |    |                             | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                           | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                          | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 6:00-18:00 Weiterbildung | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                          | 29 | 30 |
         | 31 |    |    |    |                             |    |    |
      And an unavailability should exist with reason: "education"
      And the employee "Homer" should be the unavailability's employee
      And the user "Homer" should be the unavailability's user

     When I select "Carl C" from "Mitarbeiter"
      And I wait for the spinner to stop
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |

     When I select "Homer S" from "Mitarbeiter"
      And I wait for the spinner to stop
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                          | Sa | So |
         |    |    |    |    |                             | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                           | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                          | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 6:00-18:00 Weiterbildung | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                          | 29 | 30 |
         | 31 |    |    |    |                             |    |    |

     When I follow "6:00-18:00"
      And I wait for the modal box to appear
      And I close the modal box
      And I wait for the spinner to stop
     Then the selected "Mitarbeiter" should be "Homer S"

  Scenario: Enter tow sick days, delete the first one
     When I select "ich" from "Mitarbeiter"
      And I wait for the spinner to stop
      And I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |

     When I follow "21"
      And I wait for the modal box to appear
      And I select "Krankheit" from "Grund"
      And I pick "22. Dezember 2012" from "Letzter Tag"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                     | Sa                     | So |
         |    |    |    |    |                        | 1                      | 2  |
         | 3  | 4  | 5  | 6  | 7                      | 8                      | 9  |
         | 10 | 11 | 12 | 13 | 14                     | 15                     | 16 |
         | 17 | 18 | 19 | 20 | 21 Ganztägig Krankheit | 22 Ganztägig Krankheit | 23 |
         | 24 | 25 | 26 | 27 | 28                     | 29                     | 30 |
         | 31 |    |    |    |                        |                        |    |

     When I follow "Ganztägig"
      And I wait for the modal box to appear
      And I press "Löschen"
      And I wait for the modal box to disappear
      And I wait for ember to run
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa                     | So |
         |    |    |    |    |    | 1                      | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8                      | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15                     | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 Ganztägig Krankheit | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29                     | 30 |
         | 31 |    |    |    |    |                        |    |
      # as we started
      And the selected "Mitarbeiter" should be "ich"
