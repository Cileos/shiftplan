Feature: Change locale
  In order to understand what is going on
  As a customer not speaking german
  I want to switch my locale

  # In test env, default_locale is :de, in production is :en. So in your mind, you must exchange English vs German

  Scenario: determine locale from browser
    Given I use a english browser
     When I go to the home page
     Then I should see "Welcome"

  Scenario: fallback is German
     When I go to the home page
     Then I should see "Willkommen"

  Scenario: overwrite browser detected locale with setting
    Given I use a english browser
      And the situation of a just registered user
      And I should see "News"
     When I choose "Preferences" from the drop down "owner@burns.com"
      And I follow "Advanced"
      And I select "Deutsch" from "Language"
      And I press "Update"
      And I go to the dashboard page
     Then I should not see "News"
      But I should see "Neuigkeiten"
