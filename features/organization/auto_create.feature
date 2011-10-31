Feature: Automatic creation of Organization
  In order to plan my shifts without having to deal with the concept of organizations
  As a planer
  I want to have a default organization assigned

  Scenario: created on login
    Given a planer exists
      And 0 organizations should exist
     When I sign in as the planer
     Then the planer should have 1 organizations

