Feature: Navigation
  In order to access all the wonderful functionality of clockwork
  As a user
  I want to use a navigation

  Background:
    Given the situation of a just registered user

  Scenario: as an owner with multiple organizations in same account
    # an owner can manage all organizations of the account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account

     When I am on the dashboard page
     Then I should see the following list of links within the navigation:
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
     Then I should see the following list of links within the navigation:
       | link        | active  |
       | Accounts    | false   |
       | Cileos UG   | false   |
       | Tepco GmbH  | false   |
      And I should see the following items in the account dropdown list:
       | Cileos UG   |
       | Tepco GmbH  |

     When I follow "Tepco GmbH" within the navigation
     Then I should see the following list of links within the navigation:
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
     When I follow "Cileos UG" within the navigation
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
