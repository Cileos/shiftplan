@javascript
Feature: Editing shifts of plan templates
  As a planner
  I want to edit the shifts of my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And the following teams exist:
        | team                | name                | organization      |
        | Brennstabkessel     | Brennstabkessel     | the organization  |
        | Druckwasserreaktor  | Druckwasserreaktor  | the organization  |
      And the following qualifications exist:
        | qualification      | name               | organization      |
        | Brennstabpolierer  | Brennstabpolierer  | the organization  |
        | Brennstabexperte   | Brennstabexperte   | the organization  |
      And the following shifts exists:
        | plan_template     | start_hour | end_hour | team                      |
        | the plan template | 4          | 12       | team "Druckwasserreaktor" |
      And the following demands exist:
        | demand             | quantity  | qualification                      |
        | Brennstabpolierer  | 2         | qualification "Brennstabpolierer"  |
        | Brennstabexperte   | 4         | qualification "Brennstabexperte"   |
      And the following demands shifts exist:
        | shift      | demand                          |
        | the shift  | the demand "Brennstabpolierer"  |
        | the shift  | the demand "Brennstabexperte"   |
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                                         |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 4 x Brennstabexperte 2 x Brennstabpolierer  |     |     |     |     |     |


  Scenario: Editing shifts of a plan template
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I select "13" from "Endstunde"
      And I select "Brennstabkessel" from "Team"
      And I fill in the 1st "Anzahl" with "1"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     | 04:00-13:00 3 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     |                                                         |     |     |     |     |     |

  Scenario: Making a normal shift an overnight shift
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I select "22" from "Startstunde"
      And I select "6" from "Endstunde"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi                                                      | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                                         |                                                         |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:00-24:00 4 x Brennstabexperte 2 x Brennstabpolierer  | 00:00-06:00 4 x Brennstabexperte 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing overnight shifts
    Given the following shifts exists:
        | shift      | plan_template      | start_hour  | start_minute | end_hour | end_minute | team                    |
        | overnight  | the plan template  | 22          | 15           | 6        | 45         | team "Brennstabkessel"  |
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi           | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     | 22:15-24:00                                             | 00:00-06:45  |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 4 x Brennstabexperte 2 x Brennstabpolierer  |              |     |     |     |     |
     When I click on the shift "22:15-24:00"
      And I wait for the modal box to appear
     Then the selected "Startstunde" should be "22"
      And the selected "Startminute" should be "15"
      And the selected "Endstunde" should be "6"
      And the selected "Endminute" should be "45"
     When I select "7" from "Endstunde"
      And I select "21" from "Startstunde"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi           | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     | 21:15-24:00                                             | 00:00-07:45  |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 4 x Brennstabexperte 2 x Brennstabpolierer  |              |     |     |     |     |

  Scenario: Deleting demands of shifts
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I follow "Anforderung löschen"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                   |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 4 x Brennstabexperte  |     |     |     |     |     |
