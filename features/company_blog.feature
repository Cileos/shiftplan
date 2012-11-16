@javascript
Feature: As a user
I want to create blog posts
In order to keep my colleagues informed about important news

  Background:
    Given today is "2012-05-24 12:00"
      And the situation of a just registered user
     Then 0 posts should exist

  Scenario: Creating a first blog post
    Given a confirmed user "heinz" exists with email: "heinz@example.com"
      And an employee "heinz" exists with first_name: "Heinz", last_name: "Müller", user: the confirmed user "heinz", account: the account
      And the employee "heinz" is a member in the organization
      And a confirmed user "kurt" exists with email: "kurt@example.com"
      And an employee "kurt" exists with first_name: "Kurt", last_name: "Meyer", user: the confirmed user "kurt", account: the account
      And the employee "kurt" is a member in the organization
      And a clear email queue
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization

     Then I should see "Es wurden noch keine Blogposts erstellt."
     When I follow "Alle Neuigkeiten anzeigen"
      And I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Post erfolgreich angelegt."
      And a post should exist with title: "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I should see "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I should see "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I should see "Sie haben am 24.05.2012 um 12:00 Uhr geschrieben" within the posts list
      And I should not see "Es wurden noch keine Blogposts erstellt."
      And I sign out

      # notifications
      And "heinz@example.com" should receive an email with subject "Owner Burns hat einen neuen Blogpost geschrieben"
      And "kurt@example.com" should receive an email with subject "Owner Burns hat einen neuen Blogpost geschrieben"
      But "owner@burns.com" should receive no email
     When "heinz@example.com" opens the email with subject "Owner Burns hat einen neuen Blogpost geschrieben"
     Then I should see "Owner Burns hat am 24.05.2012 um 12:00 Uhr einen neuen Blogpost geschrieben" in the email body
      And I should see "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern." in the email body
     When I click on the first link in the email
      And I fill in "E-Mail" with "heinz@example.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"

     # the blog post gets deleted
     When the post with title: "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch" is deleted

      # click on blog post link again
      And I click on the first link in the email
     # show message and redirect to the posts index page
     Then I should see "Der Blogpost wurde inzwischen gelöscht."
      And I should see "Neuigkeiten"
      And I should see "Es wurden noch keine Blogposts erstellt"


  Scenario: User visits details view of a post
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I follow "Mehr"
      And I should be on the page of the post
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"

  Scenario: Creating a blog post without entering a title
    Given I am signed in as the confirmed user "mr. burns"
      And I go to the posts page of the blog
      When I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Text" with "Da der Umweltminister kommt, denkt bitte daran, alle Kontrollräume gründlich zu säubern."
      And I press "Speichern"
     Then I should see "Titel muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Creating a blog post without entering a text
    Given I am signed in as the confirmed user "mr. burns"
      And I go to the posts page of the blog
      And I follow "Neuen Blogpost erstellen"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Umweltminister Dr. Norbert Röttgen am Freitag zu Besuch"
      And I press "Speichern"
     Then I should see "Text muss ausgefüllt werden"
      And 0 posts should exist

  Scenario: Editing a blog post
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page of the post
      And I follow "Bearbeiten"
      And I wait for the modal box to appear
     Then the "Titel" field should contain "Umweltminister zu Besuch"
      And the "Text" field should contain "Bitte putzen"
     When I fill in "Titel" with "Besuch des Umweltministers"
     When I fill in "Text" with "Bitte Kontrollräume aufräumen"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash notice "Post erfolgreich geändert."
      And I should see "Besuch des Umweltministers"
      And I should see "Bitte Kontrollräume aufräumen"

  # TODO: Open the confirm dialog in our own modal box.
  @wip
  Scenario: Deleting a blog post by pressing confirm in the dialog box
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
     When I go to the page of the post
     Then I should see "Umweltminister zu Besuch"
     When I press "Löschen"
     Then I should see "Wollen Sie den Blogpost 'Umweltminister zu Besuch' mit allen Kommentaren wirklich löschen?" in the alert box
     When I accept the popup
     Then I should see a flash notice "Post erfolgreich gelöscht."
      And I should see "Es wurden noch keine Blogposts erstellt."

  # TODO: Open the confirm dialog in our own modal box.
  @wip
  Scenario: Aborting the deletion of a blog post by pressing cancel in the dialog box
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
     When I go to the page of the post
     Then I should see "Umweltminister zu Besuch"
     When I press "Löschen"
     Then I should see "Wollen Sie den Blogpost 'Umweltminister zu Besuch' mit allen Kommentaren wirklich löschen?" in the alert box
     When I dismiss the popup
     Then I should see "Umweltminister zu Besuch"

  Scenario: Employees can only edit and destroy their own blog posts
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And a membership exists with organization: the organization, employee: the employee "bart"
      And I am signed in as the confirmed user "bart"
      And I am on the page of the post
      But I should not see "Bearbeiten"
      And I should not see "Löschen"

  Scenario: Employees can only destroy their own blog posts
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", user: the confirmed user "bart"
      And the employee "bart" is a member in the organization "fukushima"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     When I follow "Mehr"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
      But I should not see "Löschen"

  Scenario: User visits detail view of a post
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"
     When I follow "Mehr"
      And I should be on the page of the post
     Then I should see "Umweltminister zu Besuch"
      And I should see "Bitte putzen"

     When I follow "Bearbeiten"
      And I wait for the modal box to appear
      And I fill in "Titel" with "Besuch des Umweltministers"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the page of the post
      And I should see "Post erfolgreich geändert"
      And I should see "Besuch des Umweltministers"

  Scenario: Commenting blog posts
    # a post of mr. burns
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"

      And a confirmed user "lisa" exists with email: "lisa@thesimpsons.com"
      And an employee "lisa" exists with first_name: "Lisa", account: the account, user: the confirmed user "lisa"
      And a membership exists with organization: the organization, employee: the employee "lisa"
      And a confirmed user "bart" exists with email: "bart@thesimpsons.com"
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And a membership exists with organization: the organization, employee: the employee "bart"

      # lisa comments on mr. burns' blog post
      And a clear email queue
      And I am signed in as the confirmed user "lisa"
      And I am on the page of the post
     Then I should see "Es wurden noch keine Kommentare erstellt"
     When I fill in "Kommentar" with "Ich backe einen Kuchen für den Umweltminister"
      And I press "Kommentieren"
      And I wait for the spinner to disappear
     Then I should not see "Es wurden noch keine Kommentare erstellt"
      And I should see "Sie haben am 24.05.2012 um 12:00 Uhr geschrieben:" within the comments
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I should see "1 Kommentar"
      And the "Kommentar" field should contain ""
      And I sign out

     # notification for author of blog post(mr. burns)
     Then "owner@burns.com" should receive an email with subject "Lisa Simpson hat einen Ihrer Blogposts kommentiert"
      But "lisa@thesimpsons.com" should receive no email
      And "bart@thesimpsons.com" should receive no email
     When "owner@burns.com" opens the email
     Then I should see "Lisa Simpson hat Ihren Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr kommentiert" in the email body
      And I should see "Ich backe einen Kuchen für den Umweltminister" in the email body
     When I click on the first link in the email
      And I fill in "E-Mail" with "owner@burns.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should be on the page of the post
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I sign out

    # bart comments on mr. burns' blog post
      And a clear email queue
      And I am signed in as the confirmed user "bart"
      And I am on the page for the organization "fukushima"
     Then I should see "1 Kommentar"
     # cannot click the comments-count link in cucumber in some browsers because of the :before magic with the data-icon
     When I follow "Mehr"
     Then I should be on the page of the post
     When I fill in "Kommentar" with "Ich werde einen Blumenstrauß mitbringen"
      And I press "Kommentieren"
     Then I should see "2 Kommentare"
      And I sign out

     # notifications for author of blog post(mr. burns) and for the commenter "lisa"
     Then "owner@burns.com" should receive an email with subject "Bart Simpson hat einen Ihrer Blogposts kommentiert"
      And "lisa@thesimpsons.com" should receive an email with subject "Bart Simpson hat einen Blogpost ebenfalls kommentiert"
      But "bart@thesimpsons.com" should receive no email
     # blog post author mr. burns opens the email
     When "owner@burns.com" opens the email
     Then I should see "Bart Simpson hat Ihren Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr kommentiert" in the email body
      And I should see "Ich werde einen Blumenstrauß mitbringen" in the email body
     When I click on the first link in the email
      And I fill in "E-Mail" with "owner@burns.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should be on the page of the post
      And I should see "Ich werde einen Blumenstrauß mitbringen"
      And I sign out
     # commenter lisa opens the email
     When "lisa@thesimpsons.com" opens the email
     Then I should see "Bart Simpson hat den Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr ebenfalls kommentiert" in the email body
      And I should see "Ich werde einen Blumenstrauß mitbringen" in the email body
     When I click on the first link in the email
      And I fill in "E-Mail" with "lisa@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should be on the page of the post
      And I should see "Ich werde einen Blumenstrauß mitbringen"

  Scenario: Deleting comments on posts
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a comment exists with commentable: the post, employee: the employee owner "mr. burns", body: "Ich backe einen Kuchen für den Umweltminister"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the post
     When I deactivate all confirm dialogs
      And I follow the delete link
     Then I should not see "Ich backe einen Kuchen für den Umweltminister"
      And I should see "0 Kommentare"
      And I should see "Es wurden noch keine Kommentare erstellt"
      And I should be on the page of the post

  Scenario: Users can only delete their own comments on posts
    Given a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     When I follow "Mehr"
     When I fill in "Kommentar" with "Ich backe einen Kuchen für den Umweltminister"
      And I press "Kommentieren"
     Then I should see "Sie haben am 24.05.2012 um 12:00 Uhr geschrieben:" within the comments
      And I should see a delete button
      And I sign out

    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And a membership exists with organization: the organization, employee: the employee "bart"
      And I am signed in as the confirmed user "bart"
      And I am on the page for the organization "fukushima"
     When I follow "Mehr"
     Then I should see "Owner Burns schrieb am 24.05.2012 um 12:00 Uhr:" within the comments
      But I should not see a delete button

  Scenario: User paginates through blog posts
    Given the following posts exist:
      | title  | blog     | author                         |
      | Post 0 | the blog | the employee owner "mr. burns" |
      | Post 1 | the blog | the employee owner "mr. burns" |
      | Post 2 | the blog | the employee owner "mr. burns" |
      | Post 3 | the blog | the employee owner "mr. burns" |
      | Post 4 | the blog | the employee owner "mr. burns" |
      | Post 5 | the blog | the employee owner "mr. burns" |
      | Post 6 | the blog | the employee owner "mr. burns" |
      | Post 7 | the blog | the employee owner "mr. burns" |
      | Post 8 | the blog | the employee owner "mr. burns" |
      | Post 9 | the blog | the employee owner "mr. burns" |
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     When I follow "Alle Neuigkeiten anzeigen"
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
      | title   | blog     | author                         |
      | Post 0  | the blog | the employee owner "mr. burns" |
      | Post 1  | the blog | the employee owner "mr. burns" |
      | Post 2  | the blog | the employee owner "mr. burns" |
      | Post 3  | the blog | the employee owner "mr. burns" |
      | Post 4  | the blog | the employee owner "mr. burns" |
      | Post 5  | the blog | the employee owner "mr. burns" |
      | Post 6  | the blog | the employee owner "mr. burns" |
      | Post 7  | the blog | the employee owner "mr. burns" |
      | Post 8  | the blog | the employee owner "mr. burns" |
      | Post 9  | the blog | the employee owner "mr. burns" |
      | Post 10 | the blog | the employee owner "mr. burns" |
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     When I follow "Alle Neuigkeiten anzeigen"
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

