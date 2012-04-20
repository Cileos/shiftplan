@javascript
Feature:
  As the owner of shiftplan
  I want to receive feedback from users
  In order to be able to improve my application

  Scenario: Employee sends feedback without screenshot
    Given an organization "fukushima" exists with name: "Fukushima"
      And a confirmed user exists with email: "planner@fukushima.jp"
      And a planner exists with first_name: "Planner", last_name: "Burns", user: the confirmed user, organization: the organization
      And a clear email queue

     When I sign in as the confirmed user
      And I follow "Fukushima"
      And I follow "Feedback ohne Bildschirmfoto"
      And I wait for the modal box to appear
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash info "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "rw@cileos.com" should receive an email with subject "Sie haben neues Feedback erhalten von Planner Burns"
     When I open the email
     Then I should see the email delivered from "planner@fukushima.jp"
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Logged in user (not in the scope of an organization) sends feedback without screenshot
    Given an organization "fukushima" exists with name: "Fukushima"
      And a confirmed user exists with email: "planner@fukushima.jp"
      And a planner exists with first_name: "Planner", last_name: "Burns", user: the confirmed user, organization: the organization
      And a clear email queue

     When I sign in as the confirmed user
      And I follow "Shiftplan"
     Then I should be on the home page
      And I follow "Feedback ohne Bildschirmfoto"
      And I wait for the modal box to appear
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash info "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "rw@cileos.com" should receive an email with subject "Sie haben neues Feedback erhalten von planner@fukushima.jp"
     When I open the email
     Then I should see the email delivered from "planner@fukushima.jp"
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Guest sends feedback without screenshot by providing his name an email
     When I go to the home page
      And I follow "Feedback ohne Bildschirmfoto"
      And I wait for the modal box to appear
      And I fill in "Name" with "Hein Blöd"
      And I fill in "E-Mail" with "guest@example.xyz"
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash info "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "rw@cileos.com" should receive an email with subject "Sie haben neues Feedback erhalten von Hein Blöd"
     When I open the email
     Then I should see the email delivered from "guest@example.xyz"
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body

  Scenario: Guest sends feedback without screenshot by providing his email address but no name
     When I go to the home page
      And I follow "Feedback ohne Bildschirmfoto"
      And I wait for the modal box to appear
      And I fill in "E-Mail" with "guest@example.xyz"
      And I fill in "Problembeschreibung oder Verbesserungsvorschlag" with "Fehler beim Anlegen eines Mitarbeiters"
      And I press "Abschicken"
      And I wait for the modal box to disappear
     Then I should see a flash info "Vielen Dank! Wir werden Ihre Anfrage in Kürze bearbeiten"

      And "rw@cileos.com" should receive an email with subject "Sie haben neues Feedback erhalten von guest@example.xyz"
     When I open the email
     Then I should see the email delivered from "guest@example.xyz"
      And I should see "Fehler beim Anlegen eines Mitarbeiters" in the email body
