@javascript
Feature: Notification Hub
  As a user
  I want to see all my notification in the notification hub
  In order to not miss important events

  Scenario: Notification hub is updated
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And the employee "bart" is a member of the organization
      And a plan exists with organization: the organization
      And a scheduling exists with employee: employee "mr burns", plan: the plan

     When I am signed in as the user "mr burns"
      And I go to the home page
     Then I should see an empty notifications list

     When a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a comment exists with commentable: the post, employee: the employee "bart", body: "Ich bringe einen Besen mit"
      And a comment exists with commentable: the scheduling, employee: the employee "bart", body: "Bitte Reaktor abschließen nach Dienstende"
     Then I should see an empty notifications list

     When the time interval for updating the notification hub elapses
      And I wait for 2 seconds
      And I open the "notification hub" menu
     Then I should see a list of the following notifications:
       | subject       | blurb                                                                     |
       | Bart Simpson  | hat Ihre Schicht kommentiert: "Bitte Reaktor abschließen n..."            |
       | Bart Simpson  | hat "Umweltminister zu Besuch" kommentiert: "Ich bringe einen Besen mit"  |
       | Bart Simpson  | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen"                |
