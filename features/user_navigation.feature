Feature: User Navigation
  I want to see my email or my name in the user navigation

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"

  Scenario: as an owner with multiple organizations in same account
    Given an organization "cooling towers" exists with name: "Cooling Towers", account: the account
     When I am on the dashboard page

     # Only one employee exists for the current user. So we display the name of
     # the employee instead of the users email address
     # avatar are the initials of the employee
     Then I should see the following list of links within the user navigation:
       | link            | active |
       | ?               | false  |
       |                 | false  |
       | CB              | false  |
       | Einstellungen   | false  |
       | Ausloggen       | false  |

     When I choose "Springfield Nuclear Power Plant - Cooling Towers" from the drop down "Organisationen"
     Then I should see "Springfield Nuclear Power Plant - Cooling Towers" within the orientation bar
      And I should see "Charles Burns" within the orientation bar

  Scenario: a user beeing an employee for two accounts
    Given an organization "cooling towers" exists with name: "Cooling Towers", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

     When I go to the dashboard page
     # The user "c.burns@npp-springfield.com" is not in the scope of an account, yet, when
     # going to the dashboard.  So instead of showing the name of one of his
     # employees, we show the email address "c.burns@npp-springfield.com" in the
     # orientation bar.
     Then I should see "c.burns@npp-springfield.com" within the orientation bar

     When I follow "Springfield Nuclear Power Plant - Sector 7-G" within the navigation
      # Within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user
     Then I should see "Charles Burns" within the orientation bar

      # Within the scope of the account, we are now able to determine the current
      # employee and therefore display the name of the employee rather than only the
      # email address of the current user.
     When I follow "Cileos UG - Clockwork Programming" within the navigation
     Then I should see "Charles M. Burns" within the orientation bar

  @fileupload
  Scenario: avatar of the first employee having one is shown when outside of the scope of an account
    Given an organization "cooling towers" exists with name: "Cooling Towers", account: the account
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"

      And the employee "mr burns" has the avatar "features/support/images/barts_avatar.jpg"

     When I go to the dashboard page
     # use the avatar of the first employee having one
     Then I should see the avatar "barts_avatar.jpg" within the user navigation

     # Now both employees of the user have an avatar uploaded.
     # Still use the avatar of the first employee having one.
     When the employee "charles m. burns" has the avatar "app/assets/images/rails.png"
      And I go to the dashboard page
     Then I should see the avatar "barts_avatar.jpg" within the user navigation

     When I follow "Springfield Nuclear Power Plant"
     Then I should see the avatar "barts_avatar.jpg" within the user navigation
     When I follow "Cileos UG"
     Then I should see the avatar "rails.png" within the user navigation
