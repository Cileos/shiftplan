Feature: Change locale
  In order to understand what is going on
  As a customer not speaking german
  I want to switch my locale

  # In test env, default_locale is :de, in production is :en. So in your mind, you must exchange English vs German

  Scenario: determine locale from browser
    Given I use an english browser
     When I go to the home page
     Then I should see "Register or log in to continue."

  Scenario: fallback is German
     When I go to the home page
     Then I should see "Du musst Dich registrieren oder anmelden, um fortfahren zu können"

  Scenario: overwrite browser detected locale with setting
    Given I use a english browser
      And mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And the locale attribute of the user is changed to nil
     When I go to the dashboard page
     Then I should see "News"
     When I choose "Preferences" from the drop down "c.burns@npp-springfield.com"
      And I follow "Advanced"
      And I select "Deutsch" from "Language"
      And I press "Update"
      And I go to the dashboard page
     Then I should not see "News"
      But I should see "Neuigkeiten"
