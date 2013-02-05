Feature: Adopt Employee from other Organization
  As a planner
  I want to adopt existing employees of other organizations
  In order to be able to schedule an employee in several organizations

  Background:
    Given the situation of a just registered user
      And a plan "kühlungsraum" exists with name: "Kühlungsraum säubern", organization: the organization "fukushima"

      # employee of a different organization of same account
      And an organization "tschernobyl" exists with name: "Tschernobyl", account: the account "tepco"
      And a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account "tepco", user: the confirmed user "homer"
      And a membership exists with employee: the employee "homer", organization: the organization "tschernobyl"

      # employee of a different organization of same account
      And an organization "krümmel" exists with name: "Krümmel", account: the account "tepco"
      And an employee "bart" exists with first_name: "Bart", last_name: "Simpson", account: the account "tepco"
      And a membership exists with employee: the employee "bart", organization: the organization "krümmel"
      # homer is also a member of organization krümmel
      And a membership exists with employee: the employee "homer", organization: the organization "krümmel"

      # organization, employee and plan for other account
      And an account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork" exists with account: the account "cileos"
      And an employee "raphaela" exists with first_name: "Raphaela", last_name: "Wrede", account: the account "cileos"
      And a membership exists with employee: the employee "raphaela", organization: the organization "clockwork"

     When I sign in as the confirmed user "mr. burns"
      And I am on the employees page for the organization "fukushima"
      And I should see "Es existieren noch keine Mitarbeiter für diese Organisation"
      And I follow "Übernehmen"

  Scenario: Adopting employees
    Given I should be on the adopt employees page for the organization "fukushima"
      And I should see the following table of employees:
        | Übernehmen? | Name           | WAZ | E-Mail                | Status                | Organisationen       |
        |             | Burns, Owner   |     | owner@burns.com       | Aktiv                 | keine                |
        |             | Simpson, Bart  |     |                       | Noch nicht eingeladen | Krümmel              |
        |             | Simpson, Homer |     | homer@thesimpsons.com | Aktiv                 | Krümmel, Tschernobyl |

     When I press "Mitarbeiter übernehmen"
     Then I should be on the adopt employees page for the organization "fukushima"
      And I should see flash alert "Mitarbeiter konnten nicht hinzugefügt werden. Sie müssen mindestens einen Mitarbeiter auswählen."

     When I check the checkbox within the first table row
      And I check the checkbox within the second table row
      And I press "Mitarbeiter übernehmen"

     Then I should be on the employees page for the organization "fukushima"
      And I should see flash notice "Mitarbeiter erfolgreich hinzugefügt."
      And I should see the following table of employees:
        | Name          | WAZ | E-Mail          | Status                | Organisationen     |
        | Burns, Owner  |     | owner@burns.com | Aktiv                 | Fukushima          |
        | Simpson, Bart |     |                 | Noch nicht eingeladen | Fukushima, Krümmel |

     When I follow "Übernehmen"
     Then I should see the following table of employees:
        | Übernehmen? | Name           | WAZ | E-Mail                | Status | Organisationen       |
        |             | Simpson, Homer |     | homer@thesimpsons.com | Aktiv  | Krümmel, Tschernobyl |

     When I go to the page of the plan "kühlungsraum"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Owner Burns   |     |     |     |     |     |     |     |
        | Bart Simpson  |     |     |     |     |     |     |     |


   @javascript
   Scenario: Search, Clear, refine search to continue to adopt the found employees
     # Fill in (almost?) every field
     When I fill in "first_name" with "Homer" within the search form
      And I fill in "last_name" with "Simpson" within the search form
      And I fill in "email" with "homer@thesimpsons.com" within the search form
      And I select "Krümmel" from "organization" within the search form
      And I wait a bit
     Then I should see the following table of employees:
        | Name           | WAZ | E-Mail                | Status                | Organisationen       |
        | Simpson, Homer |     | homer@thesimpsons.com | Aktiv                 | Krümmel, Tschernobyl |

     # Clear
     When I follow "Suchfilter zurücksetzen"
      And I wait a bit
     Then I should see the following table of employees:
        | Name           | WAZ | E-Mail                | Status                | Organisationen       |
        | Burns, Owner   |     | owner@burns.com       | Aktiv                 | keine                |
        | Simpson, Bart  |     |                       | Noch nicht eingeladen | Krümmel              |
        | Simpson, Homer |     | homer@thesimpsons.com | Aktiv                 | Krümmel, Tschernobyl |
      And I should see "3 Mitarbeiter gefunden."

     # search that yields no results
     When I fill in "first_name" with "Heinz"
      And I wait a bit
     Then I should see the following table of employees:
        | Name  | WAZ  | E-Mail  | Status  | Organisationen  |
      And I should see "0 Mitarbeiter gefunden."
      And the adopt employee button should be disabled

     # Successful search again, work can continue
     When I follow "Suchfilter zurücksetzen"
      And I fill in "last_name" with "Simpson" within the search form
      And I wait a bit
     Then I should see the following table of employees:
        | Name           | WAZ | E-Mail                | Status                | Organisationen       |
        | Simpson, Bart  |     |                       | Noch nicht eingeladen | Krümmel              |
        | Simpson, Homer |     | homer@thesimpsons.com | Aktiv                 | Krümmel, Tschernobyl |
      And I should see "2 Mitarbeiter gefunden."
      And the adopt employee button should not be disabled
