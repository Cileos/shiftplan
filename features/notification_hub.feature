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


  Scenario: Notification hub is updated
     When I go to the home page
      And a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a plan exists with organization: the organization
      And a scheduling exists with employee: employee "mr burns", plan: the plan
      And a comment exists with commentable: the post, employee: the employee "bart", body: "Ich bringe einen Besen mit"
      And a comment exists with commentable: the scheduling, employee: the employee "bart", body: "Bitte Reaktor abschließen nach Dienstende"

     When the time interval for updating the count of the notification hub elapses
     Then I should see "3" within the notifications count
     When I follow "3" within the notification hub
     Then the notification hub should have "3" new notifications
     # We have to wait a bit to prevent
     # Selenium::WebDriver::Error::StaleElementReferenceError errors
     When I wait for 1 seconds
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
     Then I should see a list of the following notifications:
       | subject      | blurb                                                                    |
       |              |                                                                          |
       | Bart Simpson | hat Ihre Schicht kommentiert: "Bitte Reaktor abschließen n..."           |
       | Bart Simpson | hat "Umweltminister zu Besuch" kommentiert: "Ich bringe einen Besen mit" |
       | Bart Simpson | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen"               |
     When I follow "Umweltminister zu Besuch" within the notification hub
     Then I should be on the page of the post


  Scenario: Marking notifications as read
    Given a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I go to the home page
      And I open the notification hub menu
     Then the notification hub should have "1" new notifications
     # We have to wait a bit to prevent
     # Selenium::WebDriver::Error::StaleElementReferenceError errors
     When I wait for 1 seconds
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
     Then I should see a list of the following notifications:
       | subject      | blurb                                                      |
       |              |                                                            |
       | Bart Simpson | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen" |
     When I follow "Als gelesen markieren" within the notification hub
     Then should not see "Umweltminister zu Besuch" within the notification hub
      And the notification hub should have "0" new notifications


  Scenario: Mark all notifications as read
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
     When I go to the home page
      And I open the notification hub menu
     Then the notification hub should have "11" new notifications
     # We have to wait a bit to prevent
     # Selenium::WebDriver::Error::StaleElementReferenceError errors
     When I wait for 1 seconds
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
     Then I should see a list of the following notifications:
       | subject       | blurb                                 |
       |               |                                       |
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
     Then the notification hub should have "1" new notifications
     # We have to wait a bit to prevent
     # Selenium::WebDriver::Error::StaleElementReferenceError errors
     When I wait for 1 seconds
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
      #
      # Only the notifications currently displayed in the hub get marked as read.
     Then I should see a list of the following notifications:
       | subject       | blurb                               |
       |               |                                     |
       | Bart Simpson  | hat "Post 1" geschrieben: "Post 1"  |
      And I should see "1" within the notifications count

     When I follow "Alle als gelesen markieren"
     Then the notification hub should have "0" new notifications
