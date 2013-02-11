@javascript
Feature: Editing overnight shifts of plan templates
  As a planner
  I want to edit the overnight shifts of my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And a default overnight shift for the plan template exists
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                     | Mi                                     | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |                                        |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:15-23:59 3 x 2 x Brennstabpolierer  | 00:00-06:45 3 x 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing the timespan of overnight shifts by clicking on the second day
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
        | Druckwasserreaktor(D)  |     | 21:15-23:59 3 x 2 x Brennstabpolierer  | 00:00-07:45 3 x 2 x Brennstabpolierer  |     |     |     |     |

  Scenario: Editing the team of overnight shifts
    Given I click on the shift "22:15-23:59"
      And I wait for the modal box to appear
     When I select "Brennstabkessel" from "Team"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                     | Mi                                     | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     | 22:15-23:59 3 x 2 x Brennstabpolierer  | 00:00-06:45 3 x 2 x Brennstabpolierer  |     |     |     |     |
        | Druckwasserreaktor(D)  |     |                                        |                                        |     |     |     |     |

  Scenario: Deleting demands of overnight shifts
    Given I click on the shift "22:15-23:59"
      And I wait for the modal box to appear
      And I follow "Anforderung löschen"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di               | Mi               | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                  |                  |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:15-23:59 3 x  | 00:00-06:45 3 x  |     |     |     |     |

