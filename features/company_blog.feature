Feature: As a user
I want to create blog posts
In order to keep my colleagues informed about important news

  Background:
    Given today is "2012-05-24 12:00"
      And the situation of a just registered user
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"

  @javascript
  Scenario: Creating a first blog post
     Then I should see "Es wurden noch keine Blogposts erstellt."
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I should see "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I should see "24.05.2012 12:00"
      And I should see "Owner Burns"
      And I should not see "Es wurden noch keine Blogposts erstellt."
