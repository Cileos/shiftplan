Feature: Teams in plans
  Um verschiedene Tätigkeiten oder Arbeitsplätze zu unterscheiden, und diese daraus erzeugen Kürzel zu verwenden und eine Legende anzuzeigen.
  Als Planer
  Möchte ich im Plan Teamnamen/Beschreibungen verwenden, 

  Background:
    Given the situation of a nuclear reactor

  @javascript
  Scenario: Using just the full name
     When I schedule "Homer S" on "Do" for "9-17 Reaktor putzen"
     Then I should see the following calendar:
        | Mitarbeiter   | Do      |
        | Planner Burns |         |
        | Carl C        |         |
        | Lenny L       |         |
        | Homer S       | 9-17 Rp |
      And I should see the following defined items within the legend:
        | Rp | Reaktor putzen |

  @javascript
  Scenario: additionally specifying a shortcut for the team
     When I schedule "Homer S" on "Do" for "9-17 Reaktor putzen [OK]"
     Then I should see the following calendar:
        | Mitarbeiter   | Do      |
        | Planner Burns |         |
        | Carl C        |         |
        | Lenny L       |         |
        | Homer S       | 9-17 OK |
      And I should see the following defined items within the legend:
        | OK | Reaktor putzen |

