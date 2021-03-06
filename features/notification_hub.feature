@javascript
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


  Scenario: Notification hub is updated periodically
    Given a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And I go to the home page
      And all the delayed jobs are invoked

      # fake time interval configured in js has elapsed
     When the time interval for updating the count of the notification hub elapses
     Then the notification hub should have 1 unseen notification

  Scenario: Opening the notification hub
    Given the following posts exist:
      | blog      | author           | title    | body     | created_at  |
      | the blog  | employee "bart"  | Post 1   | Post 1   | 2012-12-12  |
      | the blog  | employee "bart"  | Post 2   | Post 2   | 2012-12-13  |
      | the blog  | employee "bart"  | Post 3   | Post 3   | 2012-12-14  |
      | the blog  | employee "bart"  | Post 4   | Post 4   | 2012-12-15  |
      | the blog  | employee "bart"  | Post 5   | Post 5   | 2012-12-16  |
      | the blog  | employee "bart"  | Post 6   | Post 6   | 2012-12-17  |
      | the blog  | employee "bart"  | Post 7   | Post 7   | 2012-12-18  |
      | the blog  | employee "bart"  | Post 8   | Post 8   | 2012-12-19  |
      | the blog  | employee "bart"  | Post 9   | Post 9   | 2012-12-20  |
      | the blog  | employee "bart"  | Post 10  | Post 10  | 2012-12-21  |
      | the blog  | employee "bart"  | Post 11  | Post 11  | 2012-12-22  |
      And all the delayed jobs are invoked
      And I go to the home page
     Then the notification hub should have 11 unseen notifications
      And the notification hub should have unread notifications

     When I open the notification hub menu
      And I wait for the notifications spinner to disappear
      # 10 are seen, now. The 11th notification has not been seen, yet.
     Then the notification hub should have 1 unseen notification
      And I should see a list of the following notifications:
       | subject       | blurb                                 |
       | Bart Simpson  | hat "Post 11" geschrieben: "Post 11"  |
       | Bart Simpson  | hat "Post 10" geschrieben: "Post 10"  |
       | Bart Simpson  | hat "Post 9" geschrieben: "Post 9"    |
       | Bart Simpson  | hat "Post 8" geschrieben: "Post 8"    |
       | Bart Simpson  | hat "Post 7" geschrieben: "Post 7"    |
       | Bart Simpson  | hat "Post 6" geschrieben: "Post 6"    |
       | Bart Simpson  | hat "Post 5" geschrieben: "Post 5"    |
       | Bart Simpson  | hat "Post 4" geschrieben: "Post 4"    |
       | Bart Simpson  | hat "Post 3" geschrieben: "Post 3"    |
       | Bart Simpson  | hat "Post 2" geschrieben: "Post 2"    |


  Scenario: Clicking on a notification in the hub
    Given the following posts exist:
      | blog      | author           | title    | body     | created_at  |
      | the blog  | employee "bart"  | Post 1   | Post 1   | 2012-12-12  |
     When all the delayed jobs are invoked
      And I go to the home page
      And I open the notification hub menu
      And I wait for the notifications spinner to disappear
     Then I should see a list of the following notifications:
       | subject       | blurb                                 |
       | Bart Simpson  | hat "Post 1" geschrieben: "Post 1"    |
      And the notification hub should have unread notifications

     When I follow "Post 1" within the notification hub
     Then I should be on the page of the post
      And the notification hub should not have unread notifications
     When I open the notification hub menu
      And I wait for the notifications spinner to disappear
      # notification was marked as read and is not displayed in the hub anymore
     Then I should not see "Post 1" within the notification hub
      But I should see "Alles erledigt" within the notification hub


  Scenario: Marking a notifications as read
    Given the following posts exist:
      | blog      | author           | title    | body     | created_at  |
      | the blog  | employee "bart"  | Post 1   | Post 1   | 2012-12-12  |
      And all the delayed jobs are invoked
      And I go to the home page
      And I open the notification hub menu
      And I wait for the notifications spinner to disappear
     Then I should see a list of the following notifications:
       | subject       | blurb                                 |
       | Bart Simpson  | hat "Post 1" geschrieben: "Post 1"    |

     When I follow "Als gelesen markieren" within the notification hub
      And I wait for the notifications spinner to disappear
     Then the notification hub should not have unread notifications
      And I should not see "Post 1" within the notification hub
      But I should see "Alles erledigt" within the notification hub


  Scenario: Marking all notifications as read
    Given the following posts exist:
      | blog      | author           | title    | body     | created_at  |
      | the blog  | employee "bart"  | Post 1   | Post 1   | 2012-12-12  |
      | the blog  | employee "bart"  | Post 2   | Post 2   | 2012-12-13  |
      | the blog  | employee "bart"  | Post 3   | Post 3   | 2012-12-14  |
      | the blog  | employee "bart"  | Post 4   | Post 4   | 2012-12-15  |
      | the blog  | employee "bart"  | Post 5   | Post 5   | 2012-12-16  |
      | the blog  | employee "bart"  | Post 6   | Post 6   | 2012-12-17  |
      | the blog  | employee "bart"  | Post 7   | Post 7   | 2012-12-18  |
      | the blog  | employee "bart"  | Post 8   | Post 8   | 2012-12-19  |
      | the blog  | employee "bart"  | Post 9   | Post 9   | 2012-12-20  |
      | the blog  | employee "bart"  | Post 10  | Post 10  | 2012-12-21  |
      | the blog  | employee "bart"  | Post 11  | Post 11  | 2012-12-22  |
     When all the delayed jobs are invoked
      And I go to the home page
     Then the notification hub should have 11 unseen notifications
      And the notification hub should have unread notifications
     When I open the notification hub menu
      And I wait for the notifications spinner to disappear
      # 10 are seen, now. The 11th notification has not been seen, yet.
     Then the notification hub should have 1 unseen notification
      And I should see a list of the following notifications:
       | subject       | blurb                                 |
       | Bart Simpson  | hat "Post 11" geschrieben: "Post 11"  |
       | Bart Simpson  | hat "Post 10" geschrieben: "Post 10"  |
       | Bart Simpson  | hat "Post 9" geschrieben: "Post 9"    |
       | Bart Simpson  | hat "Post 8" geschrieben: "Post 8"    |
       | Bart Simpson  | hat "Post 7" geschrieben: "Post 7"    |
       | Bart Simpson  | hat "Post 6" geschrieben: "Post 6"    |
       | Bart Simpson  | hat "Post 5" geschrieben: "Post 5"    |
       | Bart Simpson  | hat "Post 4" geschrieben: "Post 4"    |
       | Bart Simpson  | hat "Post 3" geschrieben: "Post 3"    |
       | Bart Simpson  | hat "Post 2" geschrieben: "Post 2"    |

     When I follow "Alle als gelesen markieren"
      And I wait for the notifications spinner to disappear
     Then the notification hub should not have unseen notifications
      And I should see a list of the following notifications:
       | subject       | blurb                               |
       | Bart Simpson  | hat "Post 1" geschrieben: "Post 1"  |
      And the notification hub should have unread notifications

     When I follow "Alle als gelesen markieren"
     Then I should see "Alles erledigt" within the notification hub
      And the notification hub should not have unread notifications


  Scenario: Visiting the notifications page
    Given the following posts exist:
      | blog      | author           | title    | body     | created_at  |
      | the blog  | employee "bart"  | Post 1   | Post 1   | 2012-12-12  |
      | the blog  | employee "bart"  | Post 2   | Post 2   | 2012-12-13  |
      | the blog  | employee "bart"  | Post 3   | Post 3   | 2012-12-14  |
      | the blog  | employee "bart"  | Post 4   | Post 4   | 2012-12-15  |
      | the blog  | employee "bart"  | Post 5   | Post 5   | 2012-12-16  |
      | the blog  | employee "bart"  | Post 6   | Post 6   | 2012-12-17  |
      | the blog  | employee "bart"  | Post 7   | Post 7   | 2012-12-18  |
      | the blog  | employee "bart"  | Post 8   | Post 8   | 2012-12-19  |
      | the blog  | employee "bart"  | Post 9   | Post 9   | 2012-12-20  |
      | the blog  | employee "bart"  | Post 10  | Post 10  | 2012-12-21  |
      | the blog  | employee "bart"  | Post 11  | Post 11  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 12  | Post 12  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 13  | Post 13  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 14  | Post 14  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 15  | Post 15  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 16  | Post 16  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 17  | Post 17  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 18  | Post 18  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 19  | Post 19  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 20  | Post 20  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 21  | Post 21  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 22  | Post 22  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 23  | Post 23  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 24  | Post 24  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 25  | Post 25  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 26  | Post 26  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 27  | Post 27  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 28  | Post 28  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 29  | Post 29  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 30  | Post 30  | 2012-12-22  |
      | the blog  | employee "bart"  | Post 31  | Post 31  | 2012-12-22  |
     When all the delayed jobs are invoked
      And I go to the home page
     When I open the notification hub menu
      And I wait for the notifications spinner to disappear

     When I follow "Alle anzeigen"
     # Notifications are paginated on the index page. 30 are shown on each page.
     # So one notification remains unseen.
     Then the notification hub should have 1 unseen notifications
      And the notification hub should have unread notifications
     When I follow "2" within the pagination
      And the notification hub should not have unseen notifications
      And the notification hub should have unread notifications
