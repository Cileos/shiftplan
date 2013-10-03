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
      And an employee "lisa" exists with first_name: "Lisa", account: the account, user: confirmed user "lisa"
      And the employee "lisa" is a member of the organization
      And a confirmed user "bart" exists with email: "bart@thesimpsons.com"
      And an employee "bart" exists with first_name: "Bart", account: the account, user: confirmed user "bart"
      And the employee "bart" is a member of the organization

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
     Then "c.burns@npp-springfield.com" should receive an email with subject "Lisa Simpson hat einen Ihrer Blogposts kommentiert"
     Then "bart@thesimpsons.com" should receive an email with subject "Lisa Simpson hat einen Blogpost kommentiert"
      But "lisa@thesimpsons.com" should receive no email
     When "c.burns@npp-springfield.com" opens the email
     Then I should see "Lisa Simpson hat Ihren Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr kommentiert" in the email body
      And I should see "Ich backe einen Kuchen für den Umweltminister" in the email body

      And I am signed in as the user "mr burns"
     When I click on the first link in the email
     Then I should be on the page of the post
      And I should see "Ich backe einen Kuchen für den Umweltminister"
      And I sign out

    # bart comments on mr. burns' blog post
      And a clear email queue
      And I am signed in as the confirmed user "bart"
      And I am on the page for the organization "sector 7g"
     Then I should see "1 Kommentar"
     # cannot click the comments-count link in cucumber in some browsers because of the :before magic with the data-icon
     When I follow "Umweltminister zu Besuch"
     Then I should be on the page of the post
     When I fill in "Kommentar" with "Ich werde einen Blumenstrauß mitbringen"
      And I press "Kommentieren"
     Then I should see "2 Kommentare"
      And I sign out

     # notifications for author of blog post(mr. burns) and for the commenter "lisa"
     Then "c.burns@npp-springfield.com" should receive an email with subject "Bart Simpson hat einen Ihrer Blogposts kommentiert"
      And "lisa@thesimpsons.com" should receive an email with subject "Bart Simpson hat einen Blogpost ebenfalls kommentiert"
      But "bart@thesimpsons.com" should receive no email
     # blog post author mr. burns opens the email
     When "c.burns@npp-springfield.com" opens the email
     Then I should see "Bart Simpson hat Ihren Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr kommentiert" in the email body
      And I should see "Ich werde einen Blumenstrauß mitbringen" in the email body

      And I am signed in as the user "mr burns"
     When I click on the first link in the email
     Then I should be on the page of the post
      And I should see "Ich werde einen Blumenstrauß mitbringen"
      And I sign out

     # commenter lisa opens the email
     When "lisa@thesimpsons.com" opens the email
     Then I should see "Bart Simpson hat den Blogpost 'Umweltminister zu Besuch' am 24.05.2012 um 12:00 Uhr ebenfalls kommentiert" in the email body
      And I should see "Ich werde einen Blumenstrauß mitbringen" in the email body
     When I click on the first link in the email
      And I sign in with "lisa@thesimpsons.com" "secret"
     Then I should be on the page of the post
      And I should see "Ich werde einen Blumenstrauß mitbringen"

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

  Scenario: Users can only delete their own comments on posts
    Given a post exists with blog: the blog, author: employee "mr burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I am signed in as the user "mr burns"
      And I am on the page for the organization "sector 7g"
     When I follow "Umweltminister zu Besuch"
     When I fill in "Kommentar" with "Ich backe einen Kuchen für den Umweltminister"
      And I press "Kommentieren"
     Then I should see "Sie haben am 24.05.2012 um 12:00 Uhr geschrieben:" within the comments
      And there should be a delete button on the page
      And I sign out

    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: confirmed user "bart"
      And the employee "bart" is a member of the organization
      And I am signed in as the confirmed user "bart"
      And I am on the page for the organization "sector 7g"
     When I follow "Umweltminister zu Besuch"
     Then I should see "Charles Burns schrieb am 24.05.2012 um 12:00 Uhr:" within the comments
      But there should not be a delete button on the page
