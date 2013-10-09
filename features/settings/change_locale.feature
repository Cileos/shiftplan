Feature: Change locale
  In order to understand what is going on
  As a customer not speaking german
  I want to switch my locale

  # In test env, default_locale is :de, in production is :en. So in your mind, you must exchange English vs German
  
  # we do not support polish (yet), so we fallback to the default
  Scenario Outline: determine locale from browser and set user's locale
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And the locale attribute of the user is changed to nil
      And I use an <language> browser
     When I go to the home page
     Then I should see "Register or log in to continue."
      And I fill in "E-mail" with "c.burns@npp-springfield.com"
      And I fill in "Password" with "secret"
      And I press "Log in"
     Then a user should exist with locale: "en"
      And I should see "You've logged in"

    Examples:
      | language |
      | english  |
      | polish   |


  Scenario: fallback is English when no browser language is present
     When I go to the home page
     Then I should see "Register or log in to continue."


  Scenario: overwrite browser detected locale with setting
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I use an english browser
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
