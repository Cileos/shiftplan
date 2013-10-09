Feature: Notification Emails
  As a user
  I want to turn off notification emails
  In order to not get spammed with emails from clockwork

  Scenario: Turning off notification emails
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
     When I go to the edit profile page
     Then the "E-Mail Benachrichtigungen erhalten" checkbox should be checked
     When I uncheck "E-Mail Benachrichtigungen erhalten"
      And I press "Speichern"
     Then I should be on the edit profile page
      And the "E-Mail Benachrichtigungen erhalten" checkbox should not be checked
      And a user should exist with receive_notification_emails: "false"
