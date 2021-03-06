@javascript
Feature: Creating shifts for plan templates
  As a planner
  I want to create shifts for my plan template
  In order to be able to define demands which exist for a typical work week in my organization

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
     When I am signed in as the user "mr burns"
      And the following teams exist:
        | team                | name                | organization      |
        | Brennstabkessel     | Brennstabkessel     | the organization  |
        | Druckwasserreaktor  | Druckwasserreaktor  | the organization  |
      And a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization

  Scenario: Visit the teams in week page of a plan template
    Given I go to the plan templates page for the organization
     Then I should see the following table of plan_templates:
        | Name            | Vorlagentyp    |
        | Typische Woche  | Wochenbasiert  |

     When I follow "Typische Woche" within the first table row
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |

  Scenario: Creating shifts for a plan template without a qualification
    Given I am on the teams in week page for the plan template
      And I click on cell "Di"/"Druckwasserreaktor(D)"
      And I wait for the modal box to appear
      And I schedule shift "9-17"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di           | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |              |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 09:00-17:00  |     |     |     |     |     |

  Scenario: Creating shifts for a plan template with a qualification
    Given the following qualifications exist:
        | qualification      | name               | account      |
        | Brennstabpolierer  | Brennstabpolierer  | the account  |

     When I go to the teams in week page for the plan template
      And I click on cell "Di"/"Druckwasserreaktor(D)"
      And I wait for the modal box to appear
     Then the selected "Team" of the single-select box should be "Druckwasserreaktor"
      And the selected "Tag" should be "Di"
     When I schedule shift "9-17"
      And I fill in "Anzahl" with "2"
      And I select "Brennstabpolierer" from the "Qualifikation" single-select box
      And I follow "Anforderung hinzufügen"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                  | Mo  | Di                                     | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                        |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 09:00-17:00 3 x 2 x Brennstabpolierer  |     |     |     |     |     |

  Scenario: Creating overnight shifts with 15 minute accuracy for a plan template
    Given the following qualifications exist:
        | qualification      | name               | account      |
        | Brennstabpolierer  | Brennstabpolierer  | the account  |
        | Brennstabexperte   | Brennstabexperte   | the account  |

     When I go to the teams in week page for the plan template
      And I click on cell "Di"/"Druckwasserreaktor(D)"
      And I wait for the modal box to appear
      When I schedule shift "22-6:15"
      And I fill in "Anzahl" with "2"
      And I select "Brennstabpolierer" from the "Qualifikation" single-select box
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                 | Mi                                 | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                    |                                    |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 22:00-06:15 2 x Brennstabpolierer  | 22:00-06:15 2 x Brennstabpolierer  |     |     |     |     |
