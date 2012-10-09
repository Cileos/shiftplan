Feature: Navigation
  In order to access all the wonderful functionality of shiftplan
  As a user
  I want to use a navigation

  Background:
    Given the situation of a just registered user
      And I am signed in as the confirmed user "mr. burns"

  # BUG: should the "Alle Pläne" menu be always extended?
  @todo
  @wip
  Scenario: as an owner with multiple organizations in same account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
     When I am on the dashboard page

     Then I should see the following list of links within the navigation:
       | link            | active |
       | Owner Burns     | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |
       | Dashboard       | true   |

     When I follow "Fukushima"
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | false   |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | false   |
       | Teams          | false   |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | true    |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | false   |
       | Teams          | false   |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | false   |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | false   |
       | Teams          | false   |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | false   |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | true    |
       | Teams          | false   |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | false   |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | false   |
       | Teams          | true    |

     When I follow "shiftplan"
     Then I should be on the dashboard
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | true    |

  # BUG: should the "Alle Pläne" menu be always extended?
  @todo
  @wip
  Scenario: an user beeing an employee for two accounts
    Given the user has joined another account with organization_name: "Clockwork", as: "Charles Montgomery Burns"

     When I go to the dashboard page
     # The user "owner@burns.com" is not in the scope of an account, yet, when
     # going to the dashboard.  So instead of showing the name of one of his
     # employees, we show the email address "owner@burns.com" in the
     # navigation.
     Then I should see the following list of links within the navigation:
       | link            | active |
       | owner@burns.com | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |
       | Dashboard       | true   |

     When I follow "Fukushima"
     # The user "owner@burns.com" is now in the scope of account "tepco". So in
     # the navigation we show the name of the user's employee in the tepco
     # account which is "Owner Burns".
     Then I should see the following list of links within the navigation:
       | link           | active  |
       | Owner Burns    | false   |
       | Einstellungen  | false   |
       | Ausloggen      | false   |
       | Dashboard      | false   |
       | Fukushima >>   | true    |
       | Neuigkeiten    | false   |
       | Pläne          | true    |
       | Alle Pläne     | false   |
       | Mitarbeiter    | false   |
       | Teams          | false   |

     When I go to the dashboard page
      And I follow "Clockwork"
     # The user "owner@burns.com" is now in the scope of account "cileos". So in
     # the navigation we show the name of the user's employee in the cileos
     # account which is "Charles Montgomery Burns".
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Charles Montgomery Burns  | false   |
       | Einstellungen             | false   |
       | Ausloggen                 | false   |
       | Dashboard                 | false   |
       | Clockwork >>              | true    |
       | Neuigkeiten               | false   |
       | Pläne                     | true    |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |

  @fileupload
  Scenario: avatar is only shown on page of organization, fallback to gravatar
    Given the user has joined another account with organization_name: "School", as: "Bart S"
      And a organization "school" should exist with name: "School"
      And an employee "bart" should exist with first_name: "Bart"
      And the employee "bart" has the avatar "features/support/images/barts_avatar.jpg"

      And the user has joined another account with organization_name: "Street", as: "El Barto"
      And a organization "street" should exist with name: "Street"
      And an employee "elbarto" should exist with first_name: "El", last_name: "Barto"
      And the employee "elbarto" has the avatar "app/assets/images/rails.png"

     When I go to the dashboard page
     # show (default) gravatar for user burns on the dashboard
      And I should see a tiny gravatar within the navigation

     When I follow "Fukushima"
     # show (default) gravatar for user burns in organization "Fukushima" as no avatar
     # has been uploaded for the user's employee in organization "Fukushima"
      And I should see a tiny gravatar within the navigation

     When I go to the page of the organization "school"
     Then I should see the avatar "barts_avatar.jpg" within the navigation

     When I go to the page of the organization "street"
     Then I should see the avatar "rails.png" within the navigation

  @javascript
  Scenario: (Default) gravatar for the user's email is shown in the navigation if no other avatar has been uploaded
    Given I am on the dashboard
      And I should see a tiny gravatar within the navigation

     When I follow "Fukushima"
      And I should see a tiny gravatar within the navigation
