Feature: As a logged in user
  I want to change my email address

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "marge@thebouviers.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Marge", last_name: "Bouvier"

  Scenario: Changing the email address
    Given I am signed in as the confirmed user

    When I choose "Einstellungen" from the drop down "Marge Bouvier"
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
