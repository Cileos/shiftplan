Feature: Full dates in week plan headers
  In order to find the correct day quicker
  As a planer with a big enough display
  I want to see the full date next to each weekday

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 1     | 9-17    |

  @javascript
  @mobile_screen
  Scenario: display not big enough
     When I go to the page of the plan
     Then I should see the following partial calendar:
        | Mo           | Di  | Mi  | Do  | Fr  | Sa  | So  |
        |              |     |     |     |     |     |     |
        |              |     |     |     |     |     |     |
        |              |     |     |     |     |     |     |
        | 09:00-17:00  |     |     |     |     |     |     |


  # cannot test because selenium does not see css-inserted values (our abbrs), see http://code.google.com/p/selenium/issues/detail?id=2379
  @wip
  @javascript
  @big_screen
  Scenario: display big enough
     When I go to the page of the plan
     Then I should see the following partial calendar:
        | Montag, 03.12  | Dienstag, 03.12  | Mittwoch, 03.12  | Donnerstag, 03.12  | Freitag, 03.12  | Samstag, 03.12  | Sonntag, 03.12  |
        |                |                  |                  |                    |                 |                 |                 |
        |                |                  |                  |                    |                 |                 |                 |
        |                |                  |                  |                    |                 |                 |                 |
        | 09:00-17:00    |                  |                  |                    |                 |                 |                 |
