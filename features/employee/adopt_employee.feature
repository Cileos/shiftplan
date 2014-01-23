Feature: Adopt Employee from other Organization
  As a planner
  I want to adopt existing employees of other organizations
  In order to be able to schedule an employee in several organizations

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And a plan "kühlungsraum" exists with name: "Kühlungsraum säubern", organization: the organization

      # employee of a different organization of same account
      And an organization "cooling towers" exists with name: "Cooling Towers", account: the account "springfield"
      And a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account "springfield", user: the confirmed user "homer"
      And a membership exists with employee: the employee "homer", organization: the organization "cooling towers"

      # employee of a different organization of same account
      And an organization "sector 6f" exists with name: "Sector 6-F", account: the account "springfield"
      And an employee "bart" exists with first_name: "Bart", last_name: "Simpson", account: the account "springfield"
      And a membership exists with employee: the employee "bart", organization: the organization "sector 6f"
      # homer is also a member of organization sector 6f
      And a membership exists with employee: the employee "homer", organization: the organization "sector 6f"

      # organization, employee and plan for other account
      And an account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork" exists with account: the account "cileos"
      And an employee "raphaela" exists with first_name: "Raphaela", last_name: "Wrede", account: the account "cileos"
      And a membership exists with employee: the employee "raphaela", organization: the organization "clockwork"

      And I am on the employees page for the organization "sector 7g"
      And I follow "Übernehmen"
     Then I should be on the adopt employees page for the organization "sector 7g"
      And I should see the following table of employees:
        | Übernehmen?  | Name            | WAZ  | E-Mail                 | Status                 | Organisationen              |
        |              | Simpson, Bart   |      |                        | Noch nicht eingeladen  | Sector 6-F                  |
        |              | Simpson, Homer  |      | homer@thesimpsons.com  | Aktiv                  | Cooling Towers\nSector 6-F  |

  Scenario: Adopting employees
     When I press "Mitarbeiter übernehmen"
     Then I should be on the adopt employees page for the organization "sector 7g"
      And I should see flash alert "Mitarbeiter konnten nicht hinzugefügt werden. Sie müssen mindestens einen Mitarbeiter auswählen."

     When I check the checkbox within the first table row
      And I press "Mitarbeiter übernehmen"

     Then I should be on the employees page for the organization "sector 7g"
      And I should see flash notice "Mitarbeiter erfolgreich hinzugefügt."
      And I should see the following table of employees:
        | Name            | WAZ  | E-Mail                       | Status                 | Organisationen          |
        | Burns, Charles  |      | c.burns@npp-springfield.com  | Aktiv                  | Sector 7-G              |
        | Simpson, Bart   |      |                              | Noch nicht eingeladen  | Sector 6-F\nSector 7-G  |

     When I follow "Übernehmen"
     Then I should see the following table of employees:
        | Übernehmen?  | Name            | WAZ  | E-Mail                 | Status  | Organisationen              |
        |              | Simpson, Homer  |      | homer@thesimpsons.com  | Aktiv   | Cooling Towers\nSector 6-F  |

   @javascript
   Scenario: Search, Clear, refine search to continue to adopt the found employees
     # Fill in (almost?) every field
     When I fill in "first_name" with "Homer" within the search form
      And I fill in "last_name" with "Simpson" within the search form
      And I fill in "email" with "homer@thesimpsons.com" within the search form
      And I select "Sector 6-F" from "organization" within the search form
      And I wait for the spinner to disappear
     Then I should see "1 Mitarbeiter gefunden"
      And I should see the following table of employees:
        | Name            | WAZ  | E-Mail                 | Status  | Organisationen              |
        | Simpson, Homer  |      | homer@thesimpsons.com  | Aktiv   | Cooling Towers\nSector 6-F  |

     # Clear
     When I follow "Suchfilter zurücksetzen"
      And I wait for the spinner to disappear
     Then I should see "2 Mitarbeiter gefunden."
      And I should see the following table of employees:
        | Name            | WAZ  | E-Mail                 | Status                 | Organisationen              |
        | Simpson, Bart   |      |                        | Noch nicht eingeladen  | Sector 6-F                  |
        | Simpson, Homer  |      | homer@thesimpsons.com  | Aktiv                  | Cooling Towers\nSector 6-F  |

     # search that yields no results
     When I fill in "first_name" with "Heinz"
      And I wait for the spinner to disappear
     Then I should see "0 Mitarbeiter gefunden."
      And I should see the following table of employees:
        | Name  | WAZ  | E-Mail  | Status  | Organisationen  |
      And the adopt employee button should be disabled

     # Successful search again, work can continue
     When I follow "Suchfilter zurücksetzen"
      And I fill in "last_name" with "Simpson" within the search form
      And I wait for the spinner to disappear
     Then I should see "2 Mitarbeiter gefunden."
      And I should see the following table of employees:
        | Name            | WAZ  | E-Mail                 | Status                 | Organisationen              |
        | Simpson, Bart   |      |                        | Noch nicht eingeladen  | Sector 6-F                  |
        | Simpson, Homer  |      | homer@thesimpsons.com  | Aktiv                  | Cooling Towers\nSector 6-F  |
      And the adopt employee button should not be disabled
