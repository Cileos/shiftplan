@javascript
Feature: As a user
I want to create blog posts
In order to keep my colleagues informed about important news

  Background:
    Given today is "2012-05-24 12:00"
      And the situation of a just registered user
     Then 0 posts should exist

  Scenario: Creating a first blog post
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     Then I should see "Es wurden noch keine Blogposts erstellt."
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash info "Post erfolgreich angelegt."
      And I should see "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I should see "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I should see "24.05.2012 12:00"
      And I should see "Owner Burns"
      And I should not see "Es wurden noch keine Blogposts erstellt."

  Scenario: Creating a blog post without entering a title
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
     Then I should see "Titel muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Creating a blog post without entering a text
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I press "Speichern"
     Then I should see "Text muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Editing a blog post
     When I sign in as the confirmed user "mr. burns"
    Given a post exists with blog: the blog, author: the owner "Burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I follow "AKW Fukushima GmbH"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I follow "Bearbeiten"
      And I wait for the modal box to appear
     Then the "Titel" field should contain "Umweltminister zu Besuch"
      And the "Text" field should contain "Bitte putzen"
     When I fill in "Titel" with "Besuch des Umweltministers"
     When I fill in "Text" with "Bitte Kontrollräume aufräumen"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash info "Post erfolgreich geändert."
      And I should see "Besuch des Umweltministers"
      And I should see "Bitte Kontrollräume aufräumen"

  Scenario: Employees can only edit their own blog posts
    Given a post exists with blog: the blog, author: the owner "Burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", organization: organization "fukushima", user: the confirmed user "bart"
     When I sign in as the confirmed user "bart"
      And I follow "AKW Fukushima GmbH"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
      But I should not see "Bearbeiten"
