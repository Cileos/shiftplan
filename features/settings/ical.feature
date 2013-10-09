Feature: Ical settings
  In order to by notified on my smart phone
  As a user
  I want to subscribe to my upcoming schedulings per iCal

  Scenario: create private ICAL URL
    Given I am signed in as a confirmed user
      And I am on the profile page of my employees
     When I follow "Export"
     Then I should see "Im Moment wird keiner Deiner Termine exportiert."
     When I press "meine Termine exportieren"
     Then I should see "Dies ist die Privatadresse für Deine Termine. Gib diese Adresse nur für andere Personen frei, wenn Du möchtest, das diese alle Deine Termine sehen können."
      And I should see link "ICAL"


  Scenario: reset private ICAL URL
    Given a confirmed user with private token exists
      And I am signed in as the confirmed user with private token
      And I am on the profile page of my employees
     When I follow "Export"
     Then I should see "Dies ist die Privatadresse für Deine Termine."
     When I press "Private URL zurücksetzen"
     Then I should see "Im Moment wird keiner Deiner Termine exportiert."
      And I should not see link "ICAL"

