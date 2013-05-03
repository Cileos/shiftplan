Feature: Change locale
  In order to understand what is going on
  As a customer not speaking german
  I want to switch my locale

  Scenario: switch from default German to English
    Given the situation of a just registered user
      And I should see "Neuigkeiten"
     When I choose "Einstellungen" from the drop down "owner@burns.com"
      And I follow "Erweitert"
      And I select "English" from "Sprache"
      And I press "Speichern"
      And I go to the dashboard page
     Then I should not see "Neuigkeiten"
      But I should see "News"
