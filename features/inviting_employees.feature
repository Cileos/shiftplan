Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Scenario: Inviting an employee
    Given a planner "me" exists
      And an organization "nukular" exists with planner: planner "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer"
     When I sign in as the planner "me"
     When I follow "Mitarbeiter"
     When I follow "Homer"
      And I follow "Bearbeiten"
      And I follow "Mitarbeiter einladen"
     When I fill in "E-Mail" with "homer@thesimpsons.com"
      And I press "Einladung verschicken"
     Then I should see flash notice "Die Einladung wurde erfolgreich verschickt."
      And I should be on the edit page for the employee
      And "homer@thesimpsons.com" should receive an email with subject "Sie wurden zu Shiftplan eingeladen"

     When I open the email
      And I follow "Einladung akzeptieren" in the email
      And I fill in "Passwort" with "secret!"
      And I fill in "Passwort bestätigen" with "secret!"
      And I press "Passwort setzen"
     Then I should be signed in as "homer@thesimpsons.com"
      And I should be on the home page
      And I should be signed in as "homer@thesimpsons.com"

