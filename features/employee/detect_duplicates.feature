Feature: Detect duplicate Employee
  As a planner
  to avoid the creation of possible duplicate employees
  I want to see a warning

  Background:
    Given the situation of a just registered user

      # employee heinz meier 1 (heinz.meier@fukushima.de) of same organization(fukushima)
      And a confirmed user "heinz1" exists with email: "heinz.meier@fukushima.de"
      And an employee "heinz1" exists with first_name: "Heinz", last_name: "Meier", account: the account "tepco", user: the confirmed user "heinz1"
      And a membership exists with employee: the employee "heinz1", organization: the organization "fukushima"

      # employee heinz meier 2 without email of other organization(tschernobyl)
      And an organization "tschernobyl" exists with name: "Tschernobyl", account: the account "tepco"
      And an employee "heinz2" exists with first_name: "Heinz", last_name: "Meier", account: the account "tepco"
      And a membership exists with employee: the employee "heinz2", organization: the organization "tschernobyl"
      # heinz 1 is also member of organizaion tschernobyl
      And a membership exists with employee: the employee "heinz1", organization: the organization "tschernobyl"

     When I sign in as the confirmed user "mr. burns"
      And I am on the employees page for the organization "fukushima"

  Scenario: Entering no details should inhibit duplication detection
    Given I follow "Hinzufügen"
     When I press "Anlegen"
     Then the page should be titled "Mitarbeiter anlegen"
      But I should not see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."
      And I should not see "Folgende Mitarbeiter mit gleichem Namen existieren in diesem Account."

  Scenario: Creating duplicate employee Heinz Meier
    Given I follow "Hinzufügen"
      And I fill in "Vorname" with "Heinz"
      And I fill in "Nachname" with "Meier"
      And I press "Anlegen"

      And I should see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."
      And I should see the following table of employees:
        | Übernehmen?           | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | ist bereits Mitglied  | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        |                       | Meier, Heinz  |      |                           | Noch nicht eingeladen  | Tschernobyl             |
      And the "Trotzdem anlegen" checkbox should not be checked

     When I press "Anlegen"
     Then I should see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."

     When I check "Trotzdem anlegen"
     # create employee anyway
      And I press "Anlegen"

     Then I should be on the employees page for the organization "fukushima"
      And I should see the following table of employees:
        | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | Burns, Owner  |      | owner@burns.com           | Aktiv                  | Fukushima               |
        | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        | Meier, Heinz  | 40   |                           | Noch nicht eingeladen  | Fukushima               |

  Scenario: Adopt duplicate employee Heinz Meier after trying to create
    Given I follow "Hinzufügen"
      And I fill in "Vorname" with "Heinz"
      And I fill in "Nachname" with "Meier"
      And I press "Anlegen"

      And I should see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."
      And I should see the following table of employees:
        | Übernehmen?           | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | ist bereits Mitglied  | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        |                       | Meier, Heinz  |      |                           | Noch nicht eingeladen  | Tschernobyl             |
      But I should not see "Alle Mitarbeiter sind bereits Mitglied in dieser Organisation und können daher nicht hinzugefügt werden."

     When I check the checkbox within the second table row
      And I press "Mitarbeiter übernehmen"

     Then I should be on the employees page for the organization "fukushima"
      And I should see the following table of employees:
        | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | Burns, Owner  |      | owner@burns.com           | Aktiv                  | Fukushima               |
        | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        | Meier, Heinz  |      |                           | Noch nicht eingeladen  | Fukushima, Tschernobyl  |

  Scenario: with all duplicates beeing already member of organization
    Given a membership exists with employee: the employee "heinz2", organization: the organization "fukushima"

     When I follow "Hinzufügen"
      And I fill in "Vorname" with "Heinz"
      And I fill in "Nachname" with "Meier"
      And I press "Anlegen"

      And I should see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."
      And I should see the following table of employees:
        | Übernehmen?           | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | ist bereits Mitglied  | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        | ist bereits Mitglied  | Meier, Heinz  |      |                           | Noch nicht eingeladen  | Fukushima, Tschernobyl  |
      And I should see "Alle Mitarbeiter sind bereits Mitglied in dieser Organisation und können daher nicht hinzugefügt werden."
      And the adopt employee button should be disabled


  @javascript
  Scenario: generate duplicate by editing existing employee
    Given an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account, weekly_working_time: 33
      And the employee "homer" is a member in the organization "fukushima"
      And I am on the employees page for the organization "fukushima"
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     Then I should not see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account."

     When I fill in the following:
       | Vorname  | Heinz |
       | Nachname | Meier |
      And I press "Speichern"
      And I wait for the spinner to disappear

     Then I should see "Duplikate gefunden" within the modal box
      And I should see "Es gibt bereits Mitarbeiter mit gleichem Namen in diesem Account." within the modal box
      And I press "Speichern"
      # check box "Trotzdem speichern?" not checked(raised error)
     Then I should see "Duplikate gefunden" within the modal box
     When I check "Trotzdem speichern?"
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should be on the employees page for the organization "fukushima"
      And I should see the following table of employees:
        | Name          | WAZ  | E-Mail                    | Status                 | Organisationen          |
        | Burns, Owner  |      | owner@burns.com           | Aktiv                  | Fukushima               |
        | Meier, Heinz  |      | heinz.meier@fukushima.de  | Aktiv                  | Fukushima, Tschernobyl  |
        | Meier, Heinz  | 33   |                           | Noch nicht eingeladen  | Fukushima               |
