@en
Feature: Change locale
  In order to understand what is going on
  As a customer not speaking german
  I want to switch my locale

  Scenario: determine locale from browser
    Given I use a german browser
     When I go to the home page
     Then I should see "Willkommen"

  Scenario: fallback is English
     When I go to the home page
     Then I should see "Welcome"

  Scenario: overwrite browser detected locale with setting
    Given I use a german browser
      And the situation of a just registered user
      And I should see "Neuigkeiten"
     When I choose "Einstellungen" from the drop down "owner@burns.com"
      And I follow "Erweitert"
      And I select "English" from "Sprache"
      And I press "Speichern"
      And I go to the dashboard page
     Then I should not see "Neuigkeiten"
      But I should see "News"
