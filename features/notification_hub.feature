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
     Then the notification hub should have "0" new notifications


  @javascript
  Scenario: Notification hub is updated
     When I go to the home page
      And a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a plan exists with organization: the organization
      And a scheduling exists with employee: employee "mr burns", plan: the plan
      And a comment exists with commentable: the post, employee: the employee "bart", body: "Ich bringe einen Besen mit"
      And a comment exists with commentable: the scheduling, employee: the employee "bart", body: "Bitte Reaktor abschließen nach Dienstende"

     When the time interval for updating the count of the notification hub elapses
     Then I should see "3" within the notifications count
     When I hover over the notification hub menu item
      And I open the notification hub menu
     Then the notification hub should have "3" new notifications
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
      And I should see a list of the following notifications:
       | subject      | blurb                                                                    |
       |              |                                                                          |
       | Bart Simpson | hat Ihre Schicht kommentiert: "Bitte Reaktor abschließen n..."           |
       | Bart Simpson | hat "Umweltminister zu Besuch" kommentiert: "Ich bringe einen Besen mit" |
       | Bart Simpson | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen"               |


  @javascript
  Scenario: Marking notifications as read
    Given a post exists with blog: the blog, author: employee "bart", title: "Umweltminister zu Besuch", body: "Bitte putzen"
     When I go to the home page
      And I open the notification hub menu
     Then the notification hub should have "1" new notifications
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
      And I should see a list of the following notifications:
       | subject      | blurb                                                      |
       |              |                                                            |
       | Bart Simpson | hat "Umweltminister zu Besuch" geschrieben: "Bitte putzen" |
     When I follow "Als gelesen markieren" within the notification hub
     Then should not see "Umweltminister zu Besuch" within the notification hub
      And the notification hub should have "0" new notifications


  @javascript
  Scenario: Mark all notifications as read
    Given the following posts exist:
      | blog     | author          | title        | body         | created_at |
      | the blog | employee "bart" | Hallo        | Hallo        | 2012-12-12 |
      | the blog | employee "bart" | Buenos dias  | Buenos dias  | 2012-12-13 |
      | the blog | employee "bart" | Good morning | Good morning | 2012-12-14 |
      | the blog | employee "bart" | Grüß Gott    | Grüß Gott    | 2012-12-15 |
      | the blog | employee "bart" | Bonjour      | Bonjour      | 2012-12-16 |
      | the blog | employee "bart" | Buongiorno   | Buongiorno   | 2012-12-17 |
     When I go to the home page
      And I open the notification hub menu
     Then the notification hub should have "6" new notifications
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
      And I should see a list of the following notifications:
       | subject      | blurb                                          |
       |              |                                                |
       | Bart Simpson | hat "Buongiorno" geschrieben: "Buongiorno"     |
       | Bart Simpson | hat "Bonjour" geschrieben: "Bonjour"           |
       | Bart Simpson | hat "Grüß Gott" geschrieben: "Grüß Gott"       |
       | Bart Simpson | hat "Good morning" geschrieben: "Good morning" |
       | Bart Simpson | hat "Buenos dias" geschrieben: "Buenos dias"   |

     When I follow "Alle als gelesen markieren"
      # We need to wait in order to prevent
      # Selenium::WebDriver::Error::StaleElementReferenceError errors
      And I wait for 1 seconds
      And I open the notification hub menu
     Then the notification hub should have "1" new notifications
      # The first line of the step`s table argument corresponds to the first
      # list item which only includes the "Mark all as read" link.
      # TODO: This first line should be removed when tatze changes the html.
      #
      # Only the notifications currently displayed in the hub get marked as read.
     Then I should see a list of the following notifications:
       | subject      | blurb                            |
       |              |                                  |
       | Bart Simpson | hat "Hallo" geschrieben: "Hallo" |
      And I should see "1" within the notifications count

     When I follow "Alle als gelesen markieren"
      # We need to wait in order to prevent
      # Selenium::WebDriver::Error::StaleElementReferenceError errors
      And I wait for 1 seconds
      And I open the notification hub menu
     Then the notification hub should have "0" new notifications
