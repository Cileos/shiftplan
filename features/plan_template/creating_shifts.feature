Feature: Creating shifts for plan templates
  As I planner
  I want to create shifts for my plan template
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
  Scenario: Creating shifts for a plan template
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

      And I follow "Anforderung hinzufügen"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo | Di                             | Mi | Do | Fr | Sa | So |
        | Brennstabkessel(B)    |    |                                |    |    |    |    |    |
        | Druckwasserreaktor(D) |    | 9-17 2 x Brennstabpolierer 3 x |    |    |    |    |    |
