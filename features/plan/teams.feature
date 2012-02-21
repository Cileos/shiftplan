Feature: Teams in plans
  Um verschiedene Tätigkeiten oder Arbeitsplätze zu unterscheiden, und diese daraus erzeugen Kürzel zu verwenden und eine Legende anzuzeigen.
  Als Planer
  Möchte ich im Plan Teamnamen/Beschreibungen verwenden, 


  @javascript
  Scenario:
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Donnerstag" for "9-17 Reaktor putzen"
     Then I should see the following calendar:
        | Mitarbeiter | Donnerstag |
        | Carl C      |            |
        | Lenny L     |            |
        | Homer S     | 9-17 Rp    |
      And I should see the following defined items within the legend:
        | Rp       | Reaktor putzen |
      And a scheduling should exist
      And a team should exist with name: "Reaktor putzen"
      And the team should be the scheduling's team

