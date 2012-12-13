Feature: User Navigation
  I want to see my email or my name in the user navigation

  Background:
    Given the situation of a just registered user

  Scenario: as an owner with multiple organizations in same account
    Given an organization "tschernobyl" exists with name: "Tschernobyl", account: the account
     When I am on the dashboard page

     Then I should see the following list of links within the user navigation:
       | link            | active |
       | owner@burns.com | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I follow "Tepco GmbH"
      # within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
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

  # TODO test gravatar/avator in the user navigation
  # @fileupload
  # Scenario: avatar is only shown on page of organization, fallback to gravatar
  #   Given the user has joined another account with organization_name: "School", as: "Bart S"
  #     And a organization "school" should exist with name: "School"
  #     And an employee "bart" should exist with first_name: "Bart"
  #     And the employee "bart" has the avatar "features/support/images/barts_avatar.jpg"

  #     And the user has joined another account with organization_name: "Street", as: "El Barto"
  #     And a organization "street" should exist with name: "Street"
  #     And an employee "elbarto" should exist with first_name: "El", last_name: "Barto"
  #     And the employee "elbarto" has the avatar "app/assets/images/rails.png"

  #    When I go to the dashboard page
  #    # use the avatar of the first employee having one
  #    Then I should see the avatar "barts_avatar.jpg" within the user navigation

  #    When I follow "Fukushima"
  #    # show (default) gravatar for user burns in organization "Fukushima" as no avatar
  #    # has been uploaded for the user's employee in organization "Fukushima"
  #     And I should see a tiny gravatar within the user navigation

  #    When I go to the page of the organization "school"
  #    Then I should see the avatar "barts_avatar.jpg" within the user navigation

  #    When I go to the page of the organization "street"
  #    Then I should see the avatar "rails.png" within the user navigation

  @javascript
  Scenario: (Default) gravatar for the user's email is shown in the navigation if no other avatar has been uploaded
    Given I am on the dashboard
      And I should see a tiny gravatar within the user navigation

     When I follow "Fukushima"
      And I should see a tiny gravatar within the user navigation
