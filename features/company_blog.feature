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
     When I follow "Alle Neuigkeiten anzeigen"
      And I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash info "Post erfolgreich angelegt."
      And I should see "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I should see "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I should see "Sie haben am 24.05.2012 12:00 geschrieben" within the posts
      And I should not see "Es wurden noch keine Blogposts erstellt."

  Scenario: Creating a blog post without entering a title
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
      And I follow "Alle Neuigkeiten anzeigen"
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
     Then I should see "Titel muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Creating a blog post without entering a text
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
      And I follow "Alle Neuigkeiten anzeigen"
     When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I press "Speichern"
     Then I should see "Text muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Editing a blog post
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I follow "Mehr"
      And I follow "Bearbeiten"
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

  Scenario: Deleting a blog post
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     When I follow "Mehr"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I press "Löschen"
     Then 0 posts should exist
      And I should see a flash info "Post erfolgreich gelöscht."
      And I should see "Es wurden noch keine Blogposts erstellt."

  Scenario: Employees can only edit their own blog posts
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", organization: organization "fukushima", user: the confirmed user "bart"
     When I sign in as the confirmed user "bart"
      And I follow "AKW Fukushima GmbH"
      And I follow "Mehr"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
      But I should not see "Bearbeiten"

  Scenario: Employees can only destroy their own blog posts
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", organization: organization "fukushima", user: the confirmed user "bart"
     When I sign in as the confirmed user "bart"
     When I follow "AKW Fukushima GmbH"
      And I follow "Mehr"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
      But I should not see "Löschen"

  Scenario: User visits detail view of a post
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I follow "Mehr"
     Then I should be on the page of the post
      And I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"

     When I follow "Bearbeiten"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Besuch des Umweltministers"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the page of the post
      And I should see "Post erfolgreich geändert"
      And I should see "Besuch des Umweltministers"

     When I follow "Zurück"
      And I should see "Besuch des Umweltministers"
      And I should see "Bitte putzen"

  Scenario: Commenting blog posts
    Given a post exists with blog: the blog, author: the owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
      And I follow "Mehr"
     Then I should see "Es wurden noch keine Kommentare erstellt"
     When I fill in "Kommentar" with "Ich backe einen Kuchen für den Umweltminister"
      And I press "Kommentieren"
     Then I should not see "Es wurden noch keine Kommentare erstellt"
      But I should see "Sie haben am 24.05.2012 12:00 geschrieben:" within the comments
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And the "Kommentar" field should contain ""

     When I follow "Bearbeiten"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Besuch des Umweltministers"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see "Besuch des Umweltministers"
      And I should see "Sie haben am 24.05.2012 12:00 geschrieben:" within the comments
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I sign out

    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", organization: organization "fukushima", user: the confirmed user "bart"
     When I sign in as the confirmed user "bart"
     When I follow "AKW Fukushima GmbH"
      And I follow "Mehr"
     Then I should see "Owner Burns schrieb am 24.05.2012 12:00:" within the comments

  Scenario: User paginates through blog posts
    Given the following posts exist:
      | title   | blog     | author                |
      | Post 0  | the blog | the owner "mr. burns" |
      | Post 1  | the blog | the owner "mr. burns" |
      | Post 2  | the blog | the owner "mr. burns" |
      | Post 3  | the blog | the owner "mr. burns" |
      | Post 4  | the blog | the owner "mr. burns" |
      | Post 5  | the blog | the owner "mr. burns" |
      | Post 6  | the blog | the owner "mr. burns" |
      | Post 7  | the blog | the owner "mr. burns" |
      | Post 8  | the blog | the owner "mr. burns" |
      | Post 9  | the blog | the owner "mr. burns" |
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
      And I follow "Alle Neuigkeiten anzeigen"
      And I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Post 10"
      And I fill in "Text" with "Text von Post 4"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see "Post 10"
      And I should see "Post 9"
      And I should see "Post 8"
      And I should see "Post 7"
      And I should see "Post 6"
      And I should see "Post 5"
      And I should see "Post 4"
      And I should see "Post 3"
      And I should see "Post 2"
      And I should see "Post 1"
      But I should not see "Post 0"
     When I follow ">>" within the pagination
     Then I should see "Post 0"
      But I should not see "Post 10"
      And I should not see "Post 9"
      And I should not see "Post 8"
      And I should not see "Post 7"
      And I should not see "Post 6"
      And I should not see "Post 5"
      And I should not see "Post 4"
      And I should not see "Post 3"
      And I should not see "Post 2"
      And I should not see "Post 1"

  Scenario: User paginates through blog posts
    Given the following posts exist:
      | title  | blog     | author                |
      | Post 0  | the blog | the owner "mr. burns" |
      | Post 1  | the blog | the owner "mr. burns" |
      | Post 2  | the blog | the owner "mr. burns" |
      | Post 3  | the blog | the owner "mr. burns" |
      | Post 4  | the blog | the owner "mr. burns" |
      | Post 5  | the blog | the owner "mr. burns" |
      | Post 6  | the blog | the owner "mr. burns" |
      | Post 7  | the blog | the owner "mr. burns" |
      | Post 8  | the blog | the owner "mr. burns" |
      | Post 9  | the blog | the owner "mr. burns" |
      | Post 10 | the blog | the owner "mr. burns" |
     When I sign in as the confirmed user "mr. burns"
      And I follow "AKW Fukushima GmbH"
      And I follow "Alle Neuigkeiten anzeigen"
     Then I should see "Post 10"
      And I should see "Post 9"
      And I should see "Post 8"
      And I should see "Post 7"
      And I should see "Post 6"
      And I should see "Post 5"
      And I should see "Post 4"
      And I should see "Post 3"
      And I should see "Post 2"
      And I should see "Post 1"
      But I should not see "Post 0"
     When I follow ">>" within the pagination
     Then I should see "Post 0"
      But I should not see "Post 10"
      And I should not see "Post 9"
      And I should not see "Post 8"
      And I should not see "Post 7"
      And I should not see "Post 6"
      And I should not see "Post 5"
      And I should not see "Post 4"
      And I should not see "Post 3"
      And I should not see "Post 2"
      And I should not see "Post 1"
     When I follow "<<" within the pagination
     Then I should see "Post 10"
      And I should see "Post 9"
      And I should see "Post 8"
      And I should see "Post 7"
      And I should see "Post 6"
      And I should see "Post 5"
      And I should see "Post 4"
      And I should see "Post 3"
      And I should see "Post 2"
      And I should see "Post 1"
      But I should not see "Post 0"
     When I follow "2" within the pagination
     Then I should see "Post 0"
      But I should not see "Post 10"
      And I should not see "Post 9"
      And I should not see "Post 8"
      And I should not see "Post 7"
      And I should not see "Post 6"
      And I should not see "Post 5"
      And I should not see "Post 4"
      And I should not see "Post 3"
      And I should not see "Post 2"
      And I should not see "Post 1"
     When I follow "1" within the pagination
     Then I should see "Post 10"
      And I should see "Post 9"
      And I should see "Post 8"
      And I should see "Post 7"
      And I should see "Post 6"
      And I should see "Post 5"
      And I should see "Post 4"
      And I should see "Post 3"
      And I should see "Post 2"
      And I should see "Post 1"
      But I should not see "Post 0"

