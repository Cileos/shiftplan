Feature: As a logged in user
  I want to change my email address

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "marge@thebouviers.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Marge", last_name: "Bouvier"
      And I am signed in as the confirmed user
      And I am on my dashboard

  Scenario: Changing the email address
    Given I choose "Einstellungen" from the drop down "Marge Bouvier"
     Then I should be on the edit page of the confirmed user
     When I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Aktuelles Passwort" with "secret"
      And I press "Speichern"
     Then I should be on the edit page of the confirmed user
      And I should see a flash info "schauen Sie bitte in das Postfach Ihrer neuen E-Mail Adresse"
      And "marge@thesimpsons.com" should receive an email with subject "E-Mail Adresse ändern"
      And I sign out

     When "marge@thesimpsons.com" opens the email with subject "E-Mail Adresse ändern"
     Then I should see "Bitte bestätigen Sie die Änderung Ihrer E-Mail Adresse durch Klicken auf den folgenden Link:" in the email body
     When I click the first link in the email
     Then I should be on the email change confirmation page
      And I should see "Um die Änderung Ihrer E-Mail Adresse in marge@thesimpsons.com zu bestätigen, geben Sie bitte Ihr aktuelles Passwort ein."
     When I fill in "Aktuelles Passwort" with "secret"
      And I press "Bestätigen"
     Then I should be signed in as "Marge Bouvier"
      And I should be on the page for the organization "fukushima"
      And I should see "Sie haben Ihre E-Mail Adresse erfolgreich geändert."
      And I should see "Bitte loggen Sie sich zukünftig mit der E-Mail Adresse marge@thesimpsons.com bei uns ein."

    Given I sign out
      And I am on the home page
      And I follow "Einloggen"
      And I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
      And I should see "Erfolgreich eingeloggt."



      # Filling in wrong passwords:

  Scenario: User tries to change the email address but fills in a wrong password
    Given I am on the edit page of the confirmed user

     When I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Aktuelles Passwort" with "wrongpass"
      And I press "Speichern"
     Then I should see a flash alert "Ihre E-Mail Adresse konnte nicht geändert werden."
      And I should see "ist nicht gültig"

  Scenario: User tries to confirm requested email change but fills in a wrong password on confirmation page
    Given an email change exists with user: the confirmed user, email: "marge@thesimpsons.com"

     When "marge@thesimpsons.com" opens the email with subject "E-Mail Adresse ändern"
      And I click the first link in the email
      And I fill in "Aktuelles Passwort" with "wrongpass"
      And I press "Bestätigen"
     Then I should see a flash alert "Ihre E-Mail Adresse konnte nicht geändert werden."
      And I should see "ist nicht gültig"



      # Reconfirming email changes:

  Scenario: Logged in user reconfirms an email change
    Given an email change exists with user: the confirmed user, email: "marge@thesimpsons.com"

     When "marge@thesimpsons.com" opens the email with subject "E-Mail Adresse ändern"
      And I click the first link in the email
      And I fill in "Aktuelles Passwort" with "secret"
      And I press "Bestätigen"

      # logged in user reconfirms
     When I click the first link in the email
     Then I should be on the page for the organization "fukushima"
      And I should see "Sie haben die Änderung Ihrer E-Mail Adresse bereits bestätigt."

  Scenario: Logged out user reconfirms an email change
    Given an email change exists with user: the confirmed user, email: "marge@thesimpsons.com"

     When "marge@thesimpsons.com" opens the email with subject "E-Mail Adresse ändern"
      And I click the first link in the email
      And I fill in "Aktuelles Passwort" with "secret"
      And I press "Bestätigen"
      And I sign out

      # logged out user reconfirms
     When I click the first link in the email
     Then I should be on the sign in page
      And I should see "Sie haben die Änderung Ihrer E-Mail Adresse bereits bestätigt."
      And I should see "Bitte loggen Sie sich mit Ihrer E-Mail Adresse und Ihrem Passwort ein"



      # Confirming with a wrong email change token
      # E.g. user copies the confirmation link in the email but misses some characters at the end of the token

  Scenario: User confirms email change with wrong token
    Given an email change exists with user: the confirmed user, email: "marge@thesimpsons.com"
      And the token of the email change is changed to "somewrongtoken"

     When "marge@thesimpsons.com" opens the email with subject "E-Mail Adresse ändern"
      And I click the first link in the email
     Then I should be on the homepage
      And I should see "Der Bestätigungstoken ist nicht gültig. Die Änderung Ihrer E-Mail Adresse konnte nicht akzeptiert werden."

  Scenario: Trying to change the email address to an address that already exists
    Given a confirmed user exists with email: "marge@thesimpsons.com"
      And a clear email queue

      And I choose "Einstellungen" from the drop down "Marge Bouvier"
      # entered email already exists
     When I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Aktuelles Passwort" with "secret"
      And I press "Speichern"
     Then I should see a flash alert "Ihre E-Mail Adresse konnte nicht geändert werden."
      And I should see "ist bereits vergeben"
      And "marge@thesimpsons.com" should receive no email

  @javascript
  Scenario: Show mail address suggestion if typo in email address
    Given I am on the edit page of the confirmed user

     When I fill in "E-Mail" with "marge@yaho.com"
      And I fill in "Aktuelles Passwort" with "secret"
     Then I should see "Meinten Sie marge@yahoo.com?"

     When I follow "marge@yahoo.com"
     Then the "E-Mail" field should contain "marge@yahoo.com"
      And I should not see "Meinten Sie marge@yahoo.com?"
