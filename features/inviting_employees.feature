Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given a planner "me" exists with email: "planner@fukushima.jp"
      And an organization "fukushima" exists with name: "Fukushima", planner: planner "me"
      And an employee "homer" exists with organization: organization "fukushima", first_name: "Homer"
      And a plan exists with organization: the organization, name: "Schicht im Schacht"
     When I sign in as the planner "me"
     Then I should be signed in as "planner@fukushima.jp" for the organization

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com"

     When I open the email
      And I follow "Einladung akzeptieren" in the email
      And I fill in "Passwort" with "secret!"
      And I fill in "Passwort bestätigen" with "secret!"
      And I press "Passwort setzen"
     Then I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

  Scenario: Inviting an employee with an email address of a confirmed user which has not been invited yet
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      And I invite the employee "homer" with the email address "homer@thesimpsons.com"

     When I open the email with subject "Sie wurden zu Shiftplan eingeladen"
     And I follow "Einladung akzeptieren" in the email
     Then I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

