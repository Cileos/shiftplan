@javascript
Feature: Comments in Company blog
  In order to know whether my posts anger my employees
  As a Plannner
  I want my employees to write comments on blog posts

  Background:
    Given today is "2012-05-24 12:00"
      And mr burns, owner of the Springfield Nuclear Power Plant exists


  Scenario: Commenting blog posts
    # a post of mr. burns
    Given a post exists with blog: the blog, author: employee "mr burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a confirmed user "lisa" exists with email: "lisa@thesimpsons.com"
      And an employee "lisa" exists with first_name: "Lisa", account: the account, user: the confirmed user "lisa"
      And a membership exists with organization: the organization, employee: the employee "lisa"

      # lisa comments on mr. burns' blog post
      And a clear email queue
      And I am signed in as the confirmed user "lisa"
      And I am on the page of the post
     Then I should see "Es wurden noch keine Kommentare erstellt"
     When I fill in "Kommentar" with "Ich backe einen Kuchen für den Umweltminister"
      And I press "Kommentieren"
      And I wait for the spinner to disappear
     Then a comment should exist with body: "Ich backe einen Kuchen für den Umweltminister"
      And I should not see "Es wurden noch keine Kommentare erstellt"
      And I should see "Sie haben am 24.05.2012 um 12:00 Uhr geschrieben:" within the comments
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I should see "1 Kommentar"
      And the "Kommentar" field should contain ""
      And I sign out

     # notification for author of blog post(mr. burns)
     When all the delayed jobs are invoked
     Then a comment on post of employee notification should exist with notifiable: the comment, employee: employee_owner "mr burns"
      And "c.burns@npp-springfield.com" should receive an email with subject "Lisa Simpson hat einen Ihrer Blogposts kommentiert"
     When "c.burns@npp-springfield.com" opens the email
     Then I should see "Lisa Simpson hat Ihren Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr kommentiert" in the email body
      And I should see "Ich backe einen Kuchen für den Umweltminister" in the email body

     When I am signed in as the user "mr burns"
      And I click on the first link in the email
     Then I should be on the page of the post
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I sign out


  Scenario: Deleting comments on posts
    Given a post exists with blog: the blog, author: employee "mr burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a comment exists with commentable: the post, employee: employee "mr burns", body: "Ich backe einen Kuchen für den Umweltminister"
      And I am signed in as the user "mr burns"
      And I am on the page for the post
     When I deactivate all confirm dialogs
      And I follow the delete link
     Then I should not see "Ich backe einen Kuchen für den Umweltminister"
      And I should see "0 Kommentare"
      And I should see "Es wurden noch keine Kommentare erstellt"
      And I should be on the page of the post
