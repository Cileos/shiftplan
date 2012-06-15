Feature: Navigation
  In order to access all the wonderful functionality of shiftplan
  As a user
  I want to use a navigation

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a blog exists with organization: the organization "fukushima"
      And a confirmed user exists with email: "me@shiftplan.de"
      And a employee planner exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Homer", last_name: "Simpson"

  Scenario: as a planner with multiple organizations
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
    And a employee planner exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Bart", last_name: "Simpson"
      And I am signed in as the confirmed user

     Then I should be on the dashboard page
     Then I should see the following list of links within the navigation:
       | link            | active |
       | me@shiftplan.de | false  |
       | Mein Profil     | false  |
       | Ausloggen       | false  |
       | Dashboard       | true   |

     When I follow "Fukushima GmbH"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Bart Simpson      | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Bart Simpson      | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | true   |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Bart Simpson      | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | true   |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Bart Simpson      | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | true   |
       | Teams             | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Bart Simpson      | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Dashboard         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | true   |

     When I follow "shiftplan"
     Then I should be on the landing page
     Then I should see the following list of links within the navigation:
       | link            | active |
       | me@shiftplan.de | false  |
       | Mein Profil     | false  |
       | Ausloggen       | false  |
       | Dashboard       | false  |

  Scenario: as a planner with one organization
     When I am signed in as the confirmed user

     Then I should be on the page of the organization "fukushima"
      And I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | true   |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | true   |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | false  |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | true   |
       | Teams             | false  |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | true   |
       | Neuigkeiten       | false  |
       | Pläne             | false  |
       | Alle Pläne        | false  |
       | Mitarbeiter       | false  |
       | Teams             | true   |

     When I follow "shiftplan"
     Then I should be on the landing page
     Then I should see the following list of links within the navigation:
       | link              | active |
       | Homer Simpson     | false  |
       | Mein Profil       | false  |
       | Ausloggen         | false  |
       | Fukushima GmbH >> | false  |

  @fileupload
  Scenario: Bart's avatar is shown in the navigation as only employee "bart" of logged in user has an avatar
    Given an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And a employee planner "bart" exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Bart", last_name: "Simpson"
      And the employee planner "bart" has the avatar "features/support/images/barts_avatar.jpg"
      And I am signed in as the confirmed user

     Then I should be on the dashboard page
      And I should see "me@shiftplan.de" within the navigation
      And I should see the avatar "barts_avatar.jpg" within the navigation

  @fileupload
  Scenario: Homer's avatar is shown in the navigation as only employee "homer" of logged in user has an avatar
    Given the employee planner has the avatar "app/assets/images/rails.png"
      And an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And a employee planner "bart" exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Bart", last_name: "Simpson"
      And I am signed in as the confirmed user

     Then I should be on the dashboard page
      And I should see "me@shiftplan.de" within the navigation
      And I should see the avatar "rails.png" within the navigation

  @fileupload
  Scenario: Homer's avatar is shown in the navigation as he is the first employee of the logged in user having an avatar
    Given the employee planner has the avatar "app/assets/images/rails.png"
      And an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And a employee planner "bart" exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Bart", last_name: "Simpson"
      And the employee planner "bart" has the avatar "features/support/images/barts_avatar.jpg"
      And I am signed in as the confirmed user

     Then I should be on the dashboard page
      And I should see "me@shiftplan.de" within the navigation
      And I should see the avatar "rails.png" within the navigation

  @fileupload
  Scenario: Avatar and name of the current employee is shown in the navigation when beeing in the scope of an organization
    Given the employee planner has the avatar "app/assets/images/rails.png"
      And an organization "tschernobyl" exists with name: "Tschernobyl GmbH"
      And a employee planner "bart" exists with user: the confirmed user, organization: the organization "tschernobyl", first_name: "Bart", last_name: "Simpson"
      And the employee planner "bart" has the avatar "features/support/images/barts_avatar.jpg"
      And I am signed in as the confirmed user

     When I follow "Fukushima GmbH"
     Then I should see the avatar "rails.png" within the navigation
      And I should see "Homer Simpson" within the navigation

     When I follow "Dashboard"
      And I follow "Tschernobyl GmbH"
     Then I should see the avatar "barts_avatar.jpg" within the navigation
      And I should see "Bart Simpson" within the navigation

  @javascript
  Scenario: Gravatar for the user's email is shown in the navigation if no other avatar has been uploaded
    Given a confirmed user "raphaela without avatar" exists with email: "rw@cileos.com"
      And an employee "raphaela without avatar" exists with user: the confirmed user "raphaela without avatar", organization: the organization "fukushima", first_name: "Raphaela", last_name: "Wrede"
      And I am signed in as the confirmed user "raphaela without avatar"

     Then I should see "Raphaela Wrede" within the navigation
      And I should see a tiny gravatar within the navigation
