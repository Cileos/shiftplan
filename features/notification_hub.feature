Feature: Notification Hub
  As a user
  I want to see all my notification in the notification hub
  In order to not miss important events

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And the employee "bart" is a member of the organization
      And I am signed in as the user "mr burns"


  Scenario: Notifications all done
     When I go to the home page
     Then I should see "0" within the notifications count
      And I should see "Alles erledigt" within the notification hub


  @javascript
  Scenario: Notification hub is updated
     When I go to the home page
      And a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a plan exists with organization: the organization
      And a scheduling exists with employee: employee "mr burns", plan: the plan
      And a comment exists with commentable: the post, employee: the employee "bart", body: "Ich bringe einen Besen mit"
      And a comment exists with commentable: the scheduling, employee: the employee "bart", body: "Bitte Reaktor abschließen nach Dienstende"

     When the time interval for updating the notification hub elapses
      And I wait for 2 seconds
     Then I should see "3" within the notifications count
     When I open the notification hub menu
     Then I should see a list of the following notifications:
       | subject       | blurb                                                                     |
       | Bart Simpson  | hat Ihre Schicht kommentiert: "Bitte Reaktor abschließen n..."            |
       | Bart Simpson  | hat "Umweltminister zu Besuch" kommentiert: "Ich bringe einen Besen mit"  |
       | Bart Simpson  | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen"                |


  @javascript
  Scenario: Marking notifications as read
    Given a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I go to the home page
      And I open the notification hub menu
     Then I should see a list of the following notifications:
       | subject       | blurb                                                       |
       | Bart Simpson  | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen"  |
     When I follow "Als gelesen markieren" within the notification hub
     Then should not see "Umweltminister zu Besuch" within the notification hub
      And I should see "0" within the notifications count
      And I should see "Alles erledigt" within the notification hub

