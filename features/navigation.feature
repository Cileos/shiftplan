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
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | false   |
       | Tepco GmbH - Tschernobyl  | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen      |
        | Tepco GmbH - Fukushima   |
        | Tepco GmbH - Tschernobyl |

     When I follow "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | true    |
       | Alle Organisationen       | true    |
       | Tepco GmbH - Fukushima    | false   |
       | Tepco GmbH - Tschernobyl  | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen      |
        | Tepco GmbH - Fukushima   |
        | Tepco GmbH - Tschernobyl |

     When I choose "Tepco GmbH - Fukushima" from the drop down "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | true    |
       | Dashboard                 | true    |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
       | Planvorlagen              | false   |
       | Qualifikationen           | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen      |
        | Tepco GmbH - Tschernobyl |

     When I choose "Neuigkeiten" from the drop down "Info"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | true    |
       | Dashboard                 | false   |
       | Neuigkeiten               | true    |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
       | Planvorlagen              | false   |
       | Qualifikationen           | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen      |
        | Tepco GmbH - Tschernobyl |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | false   |
       | Dashboard                 | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | true    |
       | Alle Pläne                | false   |
       | Stammdaten                | false   |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
       | Planvorlagen              | false   |
       | Qualifikationen           | false   |

     When I choose "Mitarbeiter" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | false   |
       | Dashboard                 | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | true    |
       | Mitarbeiter               | true    |
       | Teams                     | false   |
       | Planvorlagen              | false   |
       | Qualifikationen           | false   |

     When I choose "Teams" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | false   |
       | Dashboard                 | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | true    |
       | Mitarbeiter               | false   |
       | Teams                     | true    |
       | Planvorlagen              | false   |
       | Qualifikationen           | false   |

     When I choose "Planvorlagen" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | false   |
       | Dashboard                 | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | true    |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
       | Planvorlagen              | true    |
       | Qualifikationen           | false   |

     When I choose "Qualifikationen" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                      | active  |
       | Organisationen            | false   |
       | Alle Organisationen       | false   |
       | Tepco GmbH - Fukushima    | true    |
       | Tepco GmbH - Tschernobyl  | false   |
       | Info                      | false   |
       | Dashboard                 | false   |
       | Neuigkeiten               | false   |
       | Pläne                     | false   |
       | Alle Pläne                | false   |
       | Stammdaten                | true    |
       | Mitarbeiter               | false   |
       | Teams                     | false   |
       | Planvorlagen              | false   |
       | Qualifikationen           | true    |

     # Click on the selected account in the account selector in menu when beeing in the
     # scope of an organization.
     # When I follow "Tepco GmbH" within the navigation
     # Then I should be on the page of the account "tepco"
     # Then I should see the following list of links within the navigation:
     #   | link                      | active  |
     #   | Tepco GmbH                | true    |
     #   | Organisationen            | false   |
     #   | Tepco GmbH - Fukushima    | false   |
     #   | Tepco GmbH - Tschernobyl  | false   |
     #  And I should see the following items in the organization dropdown list:
     #    | Tepco GmbH - Fukushima   |
     #    | Tepco GmbH - Tschernobyl |


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
       | link                              | active |
       | Organisationen                    | false  |
       | Alle Organisationen               | false  |
       | Cileos UG - Clockwork Programming | false  |
       | Tepco GmbH - Fukushima            | false  |
       | Tepco GmbH - Tschernobyl          | false  |
      And I should see the following items in the organization dropdown list:
       | Alle Organisationen               |
       | Cileos UG - Clockwork Programming |
       | Tepco GmbH - Fukushima            |
       | Tepco GmbH - Tschernobyl          |

     When I choose "Tepco GmbH - Fukushima" from the drop down "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                              | active |
       | Organisationen                    | false  |
       | Alle Organisationen               | false  |
       | Cileos UG - Clockwork Programming | false  |
       | Tepco GmbH - Fukushima            | true   |
       | Tepco GmbH - Tschernobyl          | false  |
       | Info                              | true   |
       | Dashboard                         | true   |
       | Neuigkeiten                       | false  |
       | Pläne                             | false  |
       | Alle Pläne                        | false  |
       | Stammdaten                        | false  |
       | Mitarbeiter                       | false  |
       | Teams                             | false  |
       | Planvorlagen                      | false  |
       | Qualifikationen                   | false  |
      And I should see the following items in the organization dropdown list:
       | Alle Organisationen               |
       | Cileos UG - Clockwork Programming |
       | Tepco GmbH - Fukushima            |
       | Tepco GmbH - Tschernobyl          |
