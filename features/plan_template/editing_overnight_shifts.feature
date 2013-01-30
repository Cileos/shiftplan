@javascript
Feature: Editing overnight shifts of plan templates
  As a planner
  I want to edit the overnight shifts of my plan templates
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
     When I go to the teams in week page for the plan template
      And I click on cell "Di"/"Druckwasserreaktor(D)"
      And I wait for the modal box to appear
     When I select "22" from "Startstunde"
      And I select "15" from "Startminute"
      And I select "6" from "Endstunde"
      And I select "45" from "Endminute"
      And I fill in "Anzahl" with "2"
      And I select "Brennstabpolierer" from "Qualifikation"
      And I follow "Anforderung hinzufügen"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Anlegen"
      And I wait for the modal box to disappear
      And I should see the following calendar:
        | Teams                  | Mo  | Di                                     | Mi                                     | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |                                        |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:15-24:00 3 x 2 x Brennstabpolierer  | 00:00-06:45 3 x 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing the timespan of overnight shifts by clicking on the first day, so that it stays a overnight shift
    Given I click on the shift "22:15-24:00"
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
        | Teams                  | Mo  | Di                                     | Mi                                     | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |                                        |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 21:15-24:00 3 x 2 x Brennstabpolierer  | 00:00-07:45 3 x 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing the timespan of overnight shifts by clicking on the second day, so that it stays a overnight shift
    Given I click on the shift "00:00-06:45"
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
        | Teams                  | Mo  | Di                                     | Mi                                     | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |                                        |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 21:15-24:00 3 x 2 x Brennstabpolierer  | 00:00-07:45 3 x 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing the timespan of overnight shifts, so that it becomes a normal shift
    Given I click on the shift "22:15-24:00"
      And I wait for the modal box to appear
      And I select "23" from "Endstunde"
      And I select "30" from "Endminute"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                     | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:15-23:30 3 x 2 x Brennstabpolierer  |     |     |     |     |     |
