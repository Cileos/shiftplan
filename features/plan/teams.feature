Feature: Teams in plans
  Um verschiedene Tätigkeiten oder Arbeitsplätze zu unterscheiden, und diese daraus erzeugen Kürzel zu verwenden und eine Legende anzuzeigen.
  Als Planer
  Möchte ich im Plan Teamnamen/Beschreibungen verwenden, 


  @javascript
  Scenario:
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Donnerstag" for "9-17 Reaktorputzen"
     Then I should see the following calendar:
        | Mitarbeiter | Donnerstag         |
        | Carl C      |                    |
        | Lenny L     |                    |
        | Homer S     | 9-17 Reaktorputzen |
      And a scheduling should exist
      And a team should exist with name: "Reaktorputzen"
      And the team should be the scheduling's team

