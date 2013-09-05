@javascript
Feature: Feedback without Screenshot
  As the owner of clockwork
  I want to receive feedback from users
  In order to be able to improve my application

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
    Given the situation of a nuclear reactor
      And a clear email queue

  Scenario: Owner sends feedback
    Given I am on the page of the organization "Reactor"

     When I follow "Feedback"
      And I wait for the modal box to appear
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "support@app.clockwork.io" should receive an email with subject "Sie haben neues Feedback erhalten von Planner Burns"
     When I open the email
     Then I should see the email delivered from "burns@clockwork.local"
      And I should see "Name: Planner Burns" in the email body
      And I should see "E-Mail: burns@clockwork.local" in the email body
      And I should see "Browser: " in the email body
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Signed in multiple account user (not yet in the scope of an account) sends feedback without providing a name
    Given the confirmed user "Homer" has joined another account
      And I sign out
      And I am signed in as confirmed user "Homer"
      And I am on the home page
      And I should be on the dashboard page

     When I follow "Feedback"
      And I wait for the modal box to appear
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "support@app.clockwork.io" should receive an email with subject "Sie haben neues Feedback erhalten von homer@clockwork.local"
     When I open the email
     Then I should see the email delivered from "homer@clockwork.local"
      And I should see "Name: " in the email body
      And I should see "E-Mail: homer@clockwork.local" in the email body
      And I should see "Browser: " in the email body
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Logged in multiple account user (not yet in the scope of an account) sends feedback with providing a name
    Given the confirmed user "Homer" has joined another account
      And I sign out
      And I am signed in as confirmed user "Homer"
      And I am on the home page
     When I follow "Feedback"
      And I wait for the modal box to appear
      And I fill in "Name" with "not Mr Burns"
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "support@app.clockwork.io" should receive an email with subject "Sie haben neues Feedback erhalten von not Mr Burns"
     When I open the email
     Then I should see the email delivered from "homer@clockwork.local"
      And I should see "Name: not Mr Burns" in the email body
      And I should see "E-Mail: homer@clockwork.local" in the email body
      And I should see "Browser: " in the email body
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Guest sends feedback by providing his name and email
     When I sign out
      And I go to the home page

      And I follow "Tell us what you think"
      And I wait for the modal box to appear
      And I fill in "Your name" with "Hein Blöd"
      And I fill in "Your e-mail" with "guest@example.xyz" within the modal box
      And I fill in "Bugs, ideas" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Send"

      And I wait for the modal box to disappear
     Then I should see a flash notice "Thank's"

      And "support@app.clockwork.io" should receive an email with subject "Hein Blöd gave you some feedback"
     When I open the email
     Then I should see the email delivered from "guest@example.xyz"
      And I should see "Name: Hein Blöd" in the email body
      And I should see "E-Mail: guest@example.xyz" in the email body
      And I should see "Browser: " in the email body
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Guest sends feedback by providing his email address but no name
     When I sign out
      And I go to the home page

      And I follow "Tell us what you think!"
      And I wait for the modal box to appear
      And I fill in "Your e-mail" with "guest@example.xyz" within the modal box
      And I fill in "Bugs, ideas, praise. Tell us!" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Send"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Thank's for feedback"

      And "support@app.clockwork.io" should receive an email with subject "guest@example.xyz gave you some feedback"
     When I open the email
     Then I should see the email delivered from "guest@example.xyz"
      And I should see "Name: " in the email body
      And I should see "E-Mail: guest@example.xyz" in the email body
      And I should see "Browser: " in the email body
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

