Feature: Navigation
  In order to access all the wonderful functionality of shiftplan
  As a user
  I want to use a navigation

  Scenario: as a planner
    Given I am signed in as a planner
     
     When I am on the dashboard
     Then I should see the following list of links within the navigation:
       | link        | active |
       | Dashboard   | true   |
       | Pläne       | false  |
       | Mitarbeiter | false  |
       | Teams       | false  |
       | Ausloggen   | false  |

     When I follow "Pläne"
     Then I should see the following list of links within the navigation:
       | link        | active |
       | Dashboard   | false  |
       | Pläne       | true   |
       | Mitarbeiter | false  |
       | Teams       | false  |
       | Ausloggen   | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link        | active |
       | Dashboard   | false  |
       | Pläne       | false  |
       | Mitarbeiter | true   |
       | Teams       | false  |
       | Ausloggen   | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link        | active |
       | Dashboard   | false  |
       | Pläne       | false  |
       | Mitarbeiter | false  |
       | Teams       | true   |
       | Ausloggen   | false  |
