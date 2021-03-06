@javascript
Feature: Manage schedulings without employees
  As a planner
  I want to create and update schedulings without an employee
  and see it in the without employee row in the calendar

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  Scenario: create and update a scheduling without an employee
     Given I follow "Neue Terminierung"
      And I wait for the modal box to appear
      And I uncheck "Mo"
      And I check "Mi"
      And I schedule "22-6"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter       | Mo  | Di  | Mi           | Do           | Fr  | Sa  | So  |
        | Planner Burns     |     |     |              |              |     |     |     |
        | Carl C            |     |     |              |              |     |     |     |
        | Lenny L           |     |     |              |              |     |     |     |
        | Homer S           |     |     |              |              |     |     |     |
        | Ohne Mitarbeiter  |     |     | 22:00-06:00  | 22:00-06:00  |     |     |     |

     When I click on scheduling "22:00-06:00"
      And I wait for the modal box to appear
     When I schedule "21-7"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter       | Mo  | Di  | Mi           | Do           | Fr  | Sa  | So  |
        | Planner Burns     |     |     |              |              |     |     |     |
        | Carl C            |     |     |              |              |     |     |     |
        | Lenny L           |     |     |              |              |     |     |     |
        | Homer S           |     |     |              |              |     |     |     |
        | Ohne Mitarbeiter  |     |     | 21:00-07:00  | 21:00-07:00  |     |     |     |

