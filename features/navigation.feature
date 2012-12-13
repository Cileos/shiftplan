# we have to discuss how to handle the dashboard
Feature: Navigation
  In order to access all the wonderful functionality of clockwork
  As a user
  I want to use a navigation

  Background:
    Given the situation of a just registered user
      And I am signed in as the confirmed user "mr. burns"

  Scenario: as an owner with multiple organizations in same account
    # an owner can manage all organizations of the account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
     When I am on the dashboard page

     Then I should see the following list of links within the user navigation:
       | link            | active |
       | owner@burns.com | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

      And I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | false   |
       | Organisationen            | false   |
       | Tepco GmbH - Fukushima    | false   |
       | Tepco GmbH - Tschernobyl  | false   |
      And I should see the following items in the organization dropdown list:
        | Tepco GmbH - Fukushima   |
        | Tepco GmbH - Tschernobyl |

     When I follow "Tepco GmbH"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Organisationen            | false   |
       | Tepco GmbH - Fukushima    | false   |
       | Tepco GmbH - Tschernobyl  | false   |
      And I should see the following items in the organization dropdown list:
        | Tepco GmbH - Fukushima   |
        | Tepco GmbH - Tschernobyl |
      # within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
      And I should see the following list of links within the user navigation:
       | link            | active |
       | Owner Burns     | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I follow "Tepco GmbH - Fukushima" within the navigation
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
      And I should see the following items in the organization dropdown list:
        | Tepco GmbH - Tschernobyl |

     When I follow "Neuigkeiten"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | true    |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
      And I should see the following items in the organization dropdown list:
        | Tepco GmbH - Tschernobyl |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | true    |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |

     When I follow "Mitarbeiter"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Mitarbeiter               | true    |
       | Teams                     | false   |

     When I follow "Teams"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | true    |

  # 1.) The user has an employee with role "owner" in the account "fukushima" and therefore can
  # see all organizations of this account.
  # 2.) The user is also a normal employee in another account "Cileos UG" with a membership for
  # organization "Clockwork Programming" but has no membership for organization
  # "Clockwork Marketing".
  Scenario: a user beeing an employee for two accounts
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the confirmed user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

     When I go to the dashboard page
     # The user "owner@burns.com" is not in the scope of an account, yet, when
     # going to the dashboard.  So instead of showing the name of one of his
     # employees, we show the email address "owner@burns.com" in the
     # navigation.
     Then I should see the following list of links within the user navigation:
       | link            | active |
       | owner@burns.com | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

      And I should see the following list of links within the navigation:
       | link        | active  |
       | Accounts    | false   |
       | Cileos UG   | false   |
       | Tepco GmbH  | false   |
      And I should see the following items in the account dropdown list:
       | Cileos UG   |
       | Tepco GmbH  |

     When I follow "Tepco GmbH" within the navigation
      # within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
     Then I should see the following list of links within the user navigation:
       | link                | active |
       | Owner Burns         | false  |
       | Einstellungen       | false  |
       | Ausloggen           | false  |
      And I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Cileos UG                 | false   |
       | Organisationen            | false   |
       | Tepco GmbH - Fukushima    | false   |
       | Tepco GmbH - Tschernobyl  | false   |
      And I should see the following items in the account dropdown list:
       | Cileos UG   |
      And I should see the following items in the organization dropdown list:
       | Tepco GmbH - Fukushima   |
       | Tepco GmbH - Tschernobyl |

     When I follow "Tepco GmbH - Fukushima" within the navigation
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Tepco GmbH                | true    |
       | Cileos UG                 | false   |
       | Fukushima                 | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
      And I should see the following items in the account dropdown list:
       | Cileos UG   |
      And I should see the following items in the organization dropdown list:
       | Tepco GmbH - Tschernobyl |

      # Now navigate to the other account and check that (normal) employee only sees
      # organizations in the menu for which he has a membership.
      #
      # Within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
     When I follow "Cileos UG" within the navigation
     Then I should see the following list of links within the user navigation:
       | link                | active |
       | Charles M. Burns    | false  |
       | Einstellungen       | false  |
       | Ausloggen           | false  |
      # We can only access one organization in the cileos account. So no organization
      # dropdown is shown in the menu in this case. We only show the one organization then.
      # Also as there is only one organization we can immediately show all links (e.g. plans)
      # in the menu for the organization, though we are not in the scope of the organization,
      # yet.
      And I should see the following list of links within the navigation:
       | link                   | active  |
       | Cileos UG              | true    |
       | Tepco GmbH             | false   |
       | Clockwork Programming  | false   |
       | Neuigkeiten            | false   |
       | Pläne                  | false   |
       | Alle Pläne             | false   |
       | Mitarbeiter            | false   |
       | Teams                  | false   |
      And I should see the following items in the account dropdown list:
       | Tepco GmbH  |

     When I follow "Clockwork Programming" within the navigation
     Then I should see the following list of links within the navigation:
       | link                   | active  |
       | Cileos UG              | true    |
       | Tepco GmbH             | false   |
       | Clockwork Programming  | true    |
       | Neuigkeiten            | false   |
       | Pläne                  | false   |
       | Alle Pläne             | false   |
       | Mitarbeiter            | false   |
       | Teams                  | false   |
      And I should see the following items in the account dropdown list:
       | Tepco GmbH  |

  # Scenario: as a planner with one organization
  #   Given I am signed in as the confirmed user

  #    When I go to the page of the organization "fukushima"
  #    Then I should see the following list of links within the navigation:
  #      | link          | active |
  #      | Fukushima     | true   |
  #      | Neuigkeiten   | false  |
  #      | Pläne         | false  |
  #      | Alle Pläne    | false  |
  #      | Mitarbeiter   | false  |
  #      | Teams         | false  |

  #    When I follow "Neuigkeiten"
  #    Then I should see the following list of links within the navigation:
  #      | link          | active |
  #      | Fukushima     | true   |
  #      | Neuigkeiten   | true   |
  #      | Pläne         | false  |
  #      | Alle Pläne    | false  |
  #      | Mitarbeiter   | false  |
  #      | Teams         | false  |

  #    When I choose "Alle Pläne" from the drop down "Pläne"
  #    Then I should see the following list of links within the navigation:
  #      | link          | active |
  #      | Fukushima     | true   |
  #      | Neuigkeiten   | false  |
  #      | Pläne         | true   |
  #      | Alle Pläne    | false  |
  #      | Mitarbeiter   | false  |
  #      | Teams         | false  |

  #    When I follow "Mitarbeiter"
  #    Then I should see the following list of links within the navigation:
  #      | link          | active |
  #      | Fukushima     | true   |
  #      | Neuigkeiten   | false  |
  #      | Pläne         | false  |
  #      | Alle Pläne    | false  |
  #      | Mitarbeiter   | true   |
  #      | Teams         | false  |

  #    When I follow "Fukushima"
  #    # The user "owner@burns.com" is now in the scope of account "tepco". So in
  #    # the navigation we show the name of the user's employee in the tepco
  #    # account which is "Owner Burns".
  #    Then I should see the following list of links within the navigation:
  #      | link           | active  |
  #      | Fukushima      | true    |
  #      | Neuigkeiten    | false   |
  #      | Pläne          | false   |
  #      | Alle Pläne     | false   |
  #      | Mitarbeiter    | false   |
  #      | Teams          | false   |

  # @fileupload
  # Scenario: avatar is only shown on page of organization, fallback to gravatar
  #   Given the user has joined another account with organization_name: "School", as: "Bart S"
  #     And a organization "school" should exist with name: "School"
  #     And an employee "bart" should exist with first_name: "Bart"
  #     And the employee "bart" has the avatar "features/support/images/barts_avatar.jpg"

  #     And the user has joined another account with organization_name: "Street", as: "El Barto"
  #     And a organization "street" should exist with name: "Street"
  #     And an employee "elbarto" should exist with first_name: "El", last_name: "Barto"
  #     And the employee "elbarto" has the avatar "app/assets/images/rails.png"

  #    When I go to the dashboard page
  #    # use the avatar of the first employee having one
  #    Then I should see the avatar "barts_avatar.jpg" within the user navigation

  #    When I follow "Fukushima"
  #    # show (default) gravatar for user burns in organization "Fukushima" as no avatar
  #    # has been uploaded for the user's employee in organization "Fukushima"
  #     And I should see a tiny gravatar within the user navigation

  #    When I go to the page of the organization "school"
  #    Then I should see the avatar "barts_avatar.jpg" within the user navigation

  #    When I go to the page of the organization "street"
  #    Then I should see the avatar "rails.png" within the user navigation

  # @javascript
  # Scenario: (Default) gravatar for the user's email is shown in the navigation if no other avatar has been uploaded
  #   Given I am on the dashboard
  #     And I should see a tiny gravatar within the user navigation

  #    When I follow "Fukushima"
  #     And I should see a tiny gravatar within the user navigation
