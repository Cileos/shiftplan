Feature: Navigation
  In order to access all the wonderful functionality of shiftplan
  As a user
  I want to use a navigation

  Scenario: as a planner
    Given an organization exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "me@shiftplan.de"
      And a planner exists with user: the confirmed user, organization: the organization
      And I am signed in as the confirmed user

     When I am on the dashboard
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | true   |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

     When I follow "Fukushima GmbH"
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | false  |
       | Pläne           | false  |
       | Mitarbeiter     | false  |
       | Teams           | false  |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

     When I follow "Pläne"
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | false  |
       | Pläne           | true   |
       | Mitarbeiter     | false  |
       | Teams           | false  |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | false  |
       | Pläne           | false  |
       | Mitarbeiter     | true   |
       | Teams           | false  |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | false  |
       | Pläne           | false  |
       | Mitarbeiter     | false  |
       | Teams           | true   |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |
