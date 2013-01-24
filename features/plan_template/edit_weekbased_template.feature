Feature: Edit Weekbased Plan Template
  As I planner
  I want to edit a weekbased plan template
  In order to be able to define demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And the following teams exist:
        | team                | name                | organization      |
        | Brennstabkessel     | Brennstabkessel     | the organization  |
        | Druckwasserreaktor  | Druckwasserreaktor  | the organization  |

  Scenario: Visit the teams in week page of a plan template
    Given a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization

     When I go to the plan templates page for the organization
     Then I should see the following table of plan_templates:
        | Name            | Vorlagentyp    |
        | Typische Woche  | Wochenbasiert  |

     When I follow "Bearbeiten" within the first table row
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |

  @javascript
  Scenario: Adding shifts to a plan template
    Given a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And the following qualifications exist:
        | qualification      | name               | organization      |
        | Brennstabpolierer  | Brennstabpolierer  | the organization  |
        | Brennstabexperte   | Brennstabexperte   | the organization  |

     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |

     When I click on cell "Di"/"Druckwasserreaktor(D)"
      And I wait for the modal box to appear
     Then the selected "Team" should be "Druckwasserreaktor"
      And the selected "Tag" should be "Di"
     When I select "9" from "Startstunde"
      And I select "17" from "Endstunde"
      And I fill in "Anzahl" with "2"
      And I select "Brennstabpolierer" from "Qualifikation"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page for the plan template
      # expected day of the shift is 1, monday would be 0 (in fact it is a day offset,
      # maybe rename it later
      And the following shifts should exist:
        | plan_template      | start_hour  | end_hour  | team                       | day  |
        | the plan template  | 9           | 17        | team "Druckwasserreaktor"  | 1    |
      And the following demands should exist:
        | shift      | quantity  | qualification                      |
        | the shift  | 2         | qualification "Brennstabpolierer"  |
      # TODO: show more information of the shifts in the calendar cells
      And I should see the following calendar:
        | Teams                 | Mo | Di                         | Mi | Do | Fr | Sa | So |
        | Brennstabkessel(B)    |    |                            |    |    |    |    |    |
        | Druckwasserreaktor(D) |    | 9-17 2 x Brennstabpolierer |    |    |    |    |    |
