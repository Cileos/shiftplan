Feature: Create Weekbased Plan Template
  As I planner
  I want to create a weekbased plan template
  In order to be able to define demands which I exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And the following teams exist:
        | name               | organization      |
        | Brennstabkessel    | the organization  |
        | Druckwasserreaktor | the organization  |

  Scenario: Create weekbased plan template
    Given a plan exists with name: "Brennstabpflege", organization: the organization
     When I go to the page of the plan
      And I follow "Neue Planvorlage"
     Then I should be on the new plan template page for the organization

     When I fill in "Name" with "Typische Woche in der Brennstabpflege"
      And I select "Wochenbasiert" from "Vorlagentyp"
      And I press "Anlegen"
     Then a plan template should exist with organization: the organization
      And I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |

  # wip
  Scenario: Adding shifts to a plan template
    Given a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And the following qualifications exist:
        | name               | organization      |
        | Brennstabpolierer  | the organization  |
        | Brennstabexperte   | the organization  |

     When I follow "Planvorlagen" within the navigation
     Then I should be on the plan templates page for the organization
      And I should see the following table of plan_templates:
        | Name            | Vorlagentyp    |
        | Typische Woche  | Wochenbasiert  |

     When I follow "Bearbeiten" within the first table row
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |
