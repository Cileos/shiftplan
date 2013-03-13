Feature: Teams in plans
  Um verschiedene Tätigkeiten oder Arbeitsplätze zu unterscheiden, und diese daraus erzeugen Kürzel zu verwenden und eine Legende anzuzeigen.
  Als Planer
  Möchte ich im Plan Teamnamen/Beschreibungen verwenden,

  Background:
    Given the situation of a nuclear reactor
      And a team exists with name: "Brennstäbe wechseln", organization: the organization

  @javascript
  Scenario: Using just the full name
     When I go to the page of the plan
     Then I should see the following defined items within the inactive teams legend:
        | Bw  | Brennstäbe wechseln  |

     When I schedule "Homer S" on "Do" for "9-17 Reaktor putzen"
     Then I should see the following calendar:
        | Mitarbeiter  | Do              |
        | Carl C       |                 |
        | Lenny L      |                 |
        | Homer S      | 09:00-17:00 Rp  |
      And I should see the following defined items within the active teams legend:
        | Rp  | Reaktor putzen       |
      And I should see the following defined items within the inactive teams legend:
        | Bw  | Brennstäbe wechseln  |

  @javascript
  Scenario: additionally specifying a shortcut for the team
     When I schedule "Homer S" on "Do" for "9-17 Reaktor putzen [OK]"
     Then I should see the following calendar:
        | Mitarbeiter  | Do              |
        | Carl C       |                 |
        | Lenny L      |                 |
        | Homer S      | 09:00-17:00 OK  |
     And I should see the following defined items within the active teams legend:
        | OK  | Reaktor putzen       |
     And I should see the following defined items within the inactive teams legend:
        | Bw  | Brennstäbe wechseln  |

