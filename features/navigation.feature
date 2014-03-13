Feature: Navigation
  In order to access all the wonderful functionality of clockwork
  As a user
  I want to use a navigation

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
     When I am signed in as the user "mr burns"

  Scenario: as an owner with multiple organizations in same account
    # an owner can manage all organizations of the account
    Given an organization "cooling towners" exists with name: "Cooling Towers", account: the account

     When I am on the dashboard page
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | false   |
       | Report                                            | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen                               |
        | Springfield Nuclear Power Plant - Cooling Towers  |
        | Springfield Nuclear Power Plant - Sector 7-G      |
     When I follow "Report"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | false   |
       | Report                                            | true    |


     When I follow "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | true    |
       | Alle Organisationen                               | true    |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | false   |
       | Report                                            | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen                               |
        | Springfield Nuclear Power Plant - Cooling Towers  |
        | Springfield Nuclear Power Plant - Sector 7-G      |

     When I choose "Springfield Nuclear Power Plant - Sector 7-G" from the drop down "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | true    |
       | Dashboard                                         | true    |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | false   |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen                               |
        | Springfield Nuclear Power Plant - Cooling Towers  |
        | Springfield Nuclear Power Plant - Sector 7-G      |

     When I choose "Neuigkeiten" from the drop down "Info"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | true    |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | true    |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | false   |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |
      And I should see the following items in the organization dropdown list:
        | Alle Organisationen                               |
        | Springfield Nuclear Power Plant - Cooling Towers  |
        | Springfield Nuclear Power Plant - Sector 7-G      |

     When I choose "Alle Pläne" from the drop down "Pläne"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | false   |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | true    |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | false   |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |

     When I choose "Mitarbeiter" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | false   |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | true    |
       | Mitarbeiter                                       | true    |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |

     When I choose "Teams" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | false   |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | true    |
       | Mitarbeiter                                       | false   |
       | Teams                                             | true    |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |

     When I choose "Planvorlagen" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | false   |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | true    |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | true    |

     When I choose "Qualifikationen" from the drop down "Stammdaten"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | false   |
       | Dashboard                                         | false   |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | true    |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | true    |
       | Planvorlagen                                      | false   |

     When I choose "Report" from the drop down "Info"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | false   |
       | Report                                            | true    |

     Given an account "vogelkunde" exists with name: "Springfielder Klub für Vogelkunde"
       And an employee "charly" exists with first_name: "Charly", last_name: "Burns", account: account "vogelkunde", user: user "mr burns"
       And a organization "piepmatz" exists with name: "Piepmatz", account: account "vogelkunde"
       And the employee "charly" is the owner of the account "vogelkunde"

      When I go to the dashboard page
      Then I should see the following list of links within the navigation:
         | link                                              | active  |
         | Organisationen                                    | false   |
         | Alle Organisationen                               | false   |
         | Springfield Nuclear Power Plant - Cooling Towers  | false   |
         | Springfield Nuclear Power Plant - Sector 7-G      | false   |
         | Springfielder Klub für Vogelkunde - Piepmatz      | false   |
         | Reports                                           | false   |
         | Springfield Nuclear Power Plant                   | false   |
         | Springfielder Klub für Vogelkunde                 | false   |

      When I choose "Springfield Nuclear Power Plant" from the drop down "Reports"
      Then I should see the following list of links within the navigation:
         | link                                              | active  |
         | Organisationen                                    | false   |
         | Alle Organisationen                               | false   |
         | Springfield Nuclear Power Plant - Cooling Towers  | false   |
         | Springfield Nuclear Power Plant - Sector 7-G      | false   |
         | Springfielder Klub für Vogelkunde - Piepmatz      | false   |
         | Reports                                           | true    |
         | Springfield Nuclear Power Plant                   | true    |
         | Springfielder Klub für Vogelkunde                 | false   |

     # Click on the selected account in the account selector in menu when beeing in the
     # scope of an organization.
     # When I follow "Springfield Nuclear Power Plant" within the navigation
     # Then I should be on the page of the account "tepco"
     # Then I should see the following list of links within the navigation:
     #  | link                                              | active  |
     #  | Springfield Nuclear Power Plant                   | true    |
     #  | Organisationen                                    | false   |
     #  | Springfield Nuclear Power Plant - Sector 7-G      | false   |
     #  | Springfield Nuclear Power Plant - Cooling Towers  | false   |
     #  And I should see the following items in the organization dropdown list:
     #  | Springfield Nuclear Power Plant - Sector 7-G      |
     #  | Springfield Nuclear Power Plant - Cooling Towers  |


  # 1.) The user is owner of the the account "springfield" and therefore can see
  # all organizations of this account.
  # 2.) The user is also a normal employee
  # in another account "Cileos UG" with a membership for organization "Clockwork
  # Programming" but has no membership for organization "Clockwork Marketing".
  Scenario: a user beeing an employee for two accounts
    Given an organization "cooling towners" exists with name: "Cooling Towers", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

     When I go to the dashboard page
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Cileos UG - Clockwork Programming                 | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | false   |
       | Report                                            | false   |
      And I should see the following items in the organization dropdown list:
       | Alle Organisationen                               |
       | Cileos UG - Clockwork Programming                 |
       | Springfield Nuclear Power Plant - Cooling Towers  |
       | Springfield Nuclear Power Plant - Sector 7-G      |

     When I choose "Springfield Nuclear Power Plant - Sector 7-G" from the drop down "Organisationen"
     Then I should see the following list of links within the navigation:
       | link                                              | active  |
       | Organisationen                                    | false   |
       | Alle Organisationen                               | false   |
       | Cileos UG - Clockwork Programming                 | false   |
       | Springfield Nuclear Power Plant - Cooling Towers  | false   |
       | Springfield Nuclear Power Plant - Sector 7-G      | true    |
       | Info                                              | true    |
       | Dashboard                                         | true    |
       | Report                                            | false   |
       | Neuigkeiten                                       | false   |
       | Pläne                                             | false   |
       | Alle Pläne                                        | false   |
       | Stammdaten                                        | false   |
       | Mitarbeiter                                       | false   |
       | Teams                                             | false   |
       | Qualifikationen                                   | false   |
       | Planvorlagen                                      | false   |
      And I should see the following items in the organization dropdown list:
       | Alle Organisationen                               |
       | Cileos UG - Clockwork Programming                 |
       | Springfield Nuclear Power Plant - Cooling Towers  |
       | Springfield Nuclear Power Plant - Sector 7-G      |
