Feature: User Navigation
  I want to see my email or my name in the user navigation

  Background:
    Given the situation of a just registered user

  Scenario: as an owner with multiple organizations in same account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
     When I am on the dashboard page

     # Only one employee exists for the current user. So we display the name of
     # the employee instead of the users email address
     Then I should see the following list of links within the user navigation:
       | link            | active |
       | Owner Burns     | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I follow "Tepco GmbH"
      And I should see the following list of links within the user navigation:
       | link            | active |
       | Owner Burns     | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I follow "Tepco GmbH - Fukushima" within the navigation
     Then I should see the following list of links within the user navigation:
       | link            | active |
       | Owner Burns     | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

  Scenario: a user beeing an employee for two accounts
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the confirmed user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

     When I go to the dashboard page
     # The user "owner@burns.com" is not in the scope of an account, yet, when
     # going to the dashboard.  So instead of showing the name of one of his
     # employees, we show the email address "owner@burns.com" in the
     # navigation.
     Then I should see the following list of links within the user navigation:
       | link            | active |
       | owner@burns.com | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I follow "Tepco GmbH" within the navigation
      # Within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
     Then I should see the following list of links within the user navigation:
       | link                | active |
       | Owner Burns         | false  |
       | Einstellungen       | false  |
       | Ausloggen           | false  |

      # Within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user.
     When I follow "Cileos UG" within the navigation
     Then I should see the following list of links within the user navigation:
       | link                | active |
       | Charles M. Burns    | false  |
       | Einstellungen       | false  |
       | Ausloggen           | false  |

  @fileupload
  Scenario: avatar of the first employee having one is shown when outside of the scope of an account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the confirmed user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

      And the employee "mr. burns" has the avatar "features/support/images/barts_avatar.jpg"

     When I go to the dashboard page
     # use the avatar of the first employee having one
     Then I should see the avatar "barts_avatar.jpg" within the user navigation

     # Now both employees of the user have an avatar uploaded.
     # Still use the avatar of the first employee having one.
     When the employee "charles m. burns" has the avatar "app/assets/images/rails.png"
      And I go to the dashboard page
     Then I should see the avatar "barts_avatar.jpg" within the user navigation

     When I follow "Tepco GmbH"
     Then I should see the avatar "barts_avatar.jpg" within the user navigation
     When I follow "Cileos UG"
     Then I should see the avatar "rails.png" within the user navigation

  @javascript
  Scenario: (Default) gravatar for the user's email is shown in the navigation if no other avatar has been uploaded
    Given I am on the dashboard
      And I should see a tiny gravatar within the user navigation

     When I follow "Fukushima"
      And I should see a tiny gravatar within the user navigation
