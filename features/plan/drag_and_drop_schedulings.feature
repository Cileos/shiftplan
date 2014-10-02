@javascript
Feature: Drag & Drop Schedulings of a Plan
  In order to arrange my workforce without having to click so much
  As a planner
  I want move Schedulings from one day/employee/team to another

  Background:
    Given the situation of a nuclear reactor

  Scenario: dragging a scheduling around
    Given the following teams exist:
        | name   | organization     |
        | Putzen | the organization |
        | Sitzen | the organization |
      And the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie        |
        | 2012-12-21 | 7-23:15 Putzen |

     When I go to the employees in week page for the plan for cwyear: 2012, week: 51
     Then I should see the following partial calendar:
        | Mitarbeiter   | Fr            |
        | Planner Burns |               |
        | Carl C        |               |
        | Lenny L       | 07:00-23:15 P |
        | Homer S       |               |

     When I drag "07:00-23:15" and drop it onto cell "Fr"/"Homer S"
     Then I should see the following partial calendar:
        | Mitarbeiter   | Fr            |
        | Planner Burns |               |
        | Carl C        |               |
        | Lenny L       |               |
        | Homer S       | 07:00-23:15 P |

     When I drag "07:00-23:15" and drop it onto cell "Mo"/"Carl C"
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo            | Fr |
        | Planner Burns |               |    |
        | Carl C        | 07:00-23:15 P |    |
        | Lenny L       |               |    |
        | Homer S       |               |    |

     When I go to the teams in week page for the plan for cwyear: 2012, week: 51
     Then I should see the following partial calendar:
        | Teams      | Mo                 | Fr |
        | Putzen (P) | Carl C 07:00-23:15 |    |
        | Sitzen (S) |                    |    |
     When I drag "07:00-23:15" and drop it onto cell "Fr"/"Sitzen"
     Then I should see the following partial calendar:
        | Teams      | Mo | Fr                 |
        | Putzen (P) |    |                    |
        | Sitzen (S) |    | Carl C 07:00-23:15 |

     When I go to the hours in week page for the plan for cwyear: 2012, week: 51
     Then I should see the following partial calendar:
        | Mo | Fr                   |
        |    | Carl C 07:00-23:15 S |
     When I drag "07:00-23:15" and drop it onto column "Mo"
     Then I should see the following partial calendar:
        | Mo                   | Fr |
        | Carl C 07:00-23:15 S |    |
