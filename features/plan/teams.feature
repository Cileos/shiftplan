Feature: Teams in legend of plan
  Um verschiedene Tätigkeiten oder Arbeitsplätze zu unterscheiden, und diese daraus erzeugen Kürzel zu verwenden und eine Legende anzuzeigen.
  Als Planer
  Möchte ich im Plan Teamnamen/Beschreibungen verwenden,

  @javascript
  Scenario: implicitly create a new team with full name and shortcut
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Do" for "9-17 Reaktor putzen [OK]"
     Then I should see the following partial calendar:
        | Mitarbeiter  | Do              |
        | Carl C       |                 |
        | Lenny L      |                 |
        | Homer S      | 09:00-17:00 OK  |
     And I should see the following defined items within the active teams legend:
        | OK  | Reaktor putzen       |
     And I should see the following defined items within the inactive teams legend:
        | Bw  | Brennstäbe wechseln  |

