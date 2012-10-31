Feature: Avatars in company blog
  In order to quickly distinguish my employees
  I want them to have avatars

  Background:
    Given today is "2012-05-24 12:00"
      And the situation of a just registered user

  @fileupload
  Scenario: Avatars of authors of posts and comments
    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: the confirmed user "bart"
      And the employee "bart" is a member of the organization
      And the employee "bart" has the avatar "app/assets/images/rails.png"
      And a post exists with blog: the blog, author: the employee owner "mr. burns", title: "Umweltminister zu Besuch", body: "Bitte putzen"
      And a comment exists with commentable: the post, employee: the employee "bart", body: "Ich bringe einen Besen mit"
      And I am signed in as the confirmed user "mr. burns"
      And I am on the page for the organization "fukushima"
     Then I should see a thumb gravatar within the first post
     When I follow "Mehr"
     Then I should see a thumb gravatar within the first post
      And I should see the avatar "rails.png" within the comment
