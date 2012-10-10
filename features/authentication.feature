Feature: Authentication
  # I want to be redirected to the sign in form if I try to access a protected page where log in required.
  # I want to be redirected to the initially requested page after successfully signing in

  Scenario: Redirect to log in form with return to
    # week 49
    Given today is 2011-12-04
      And the situation of a just registered user
      And a plan "reaktor putzen" exists with organization: the organization, name: "Reaktor putzen in Fukushima"
     # redirected to sign in page
     When I go to the page of the plan
     Then I should be on the signin page
     When I fill in "E-Mail" with "owner@burns.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     # redirected to initially requested page
     Then I should be on the employees in week page of the plan for year: 2011, week: 48
