Feature: Navigation
  In order to access all the wonderful functionality of shiftplan
  As a user
  I want to use a navigation

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a blog exists with organization: the organization "fukushima"
      And a confirmed user exists with email: "me@shiftplan.de"
      And a employee planner exists with user: the confirmed user, organization: the organization "fukushima"

  Scenario: as a planner with multiple organizations
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And a employee planner exists with user: the confirmed user, organization: the organization "fukushima"
      And I am signed in as the confirmed user

     Then I should be on the dashboard page
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | true   |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

     When I follow "Fukushima GmbH"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | true   |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | true   |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | true   |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | true   |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "shiftplan"
     Then I should be on the landing page
     Then I should see the following list of links within the navigation:
       | link            | active |
       | Dashboard       | false  |
       | me@shiftplan.de | false  |
       | Ausloggen       | false  |

  Scenario: as a planner with one organization
     When I am signed in as the confirmed user

     Then I should be on the page of the organization "fukushima"
      And I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | true   |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | true   |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | true   |
       | Teams             | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | true   |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |

     When I follow "shiftplan"
     Then I should be on the landing page
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Fukushima GmbH >> | false  |
       | me@shiftplan.de   | false  |
       | Ausloggen         | false  |
