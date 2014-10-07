@javascript
Feature: Drag & Drop Shifts of a Plantemplate
  In order to prepare my workforce without having to click so much
  As a planner
  I want move Shifts from one team to another

  Scenario: Editing shifts of a plan template
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And the situation of a plan template organization
      And I am signed in as the user "mr burns"
      And I am on the teams in week page for the plan template
      And I should see the following partial calendar:
        | Teams                 | Mo | Di                                                     | Mi |
        | Brennstabkessel(B)    |    |                                                        |    |
        | Druckwasserreaktor(D) |    | 04:00-12:00 4 x Brennstabexperte 2 x Brennstabpolierer |    |

     When I drag "04:00-12:00" and drop it onto cell "Mo"/"Brennstabkessel(B)"
     Then I should see the following partial calendar:
        | Teams                 | Mo                                                     | Di | Mi |
        | Brennstabkessel(B)    | 04:00-12:00 4 x Brennstabexperte 2 x Brennstabpolierer |    |    |
        | Druckwasserreaktor(D) |                                                        |    |    |
