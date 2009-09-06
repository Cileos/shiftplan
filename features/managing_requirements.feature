# @requirements
# Feature: Managing requirements
#   In order to be able to define requirements for workplaces
#   As a shift manager
#   I want to be able to manage requirements
# 
#   Background:
#     Given the following requirements:
#      | workplace | start          | end            | quantity |
#      | Bar       | 2009-8-8 17:00 | 2009-8-8 23:00 | 2        |
#      | Kitchen   | 2009-8-8 17:00 | 2009-8-8 23:00 | 1        |
#      | Reception | 2009-8-8 17:00 | 2009-8-8 23:00 | 1        |
#     And the following allocations:
#      | employee         | workplace |
#      | Sven Fuchs       | Bar       |
#      | Ines Kozlowski   | Kitchen   |
# 
#   @white
#   Scenario: Listing all requirements per day
#     When I go to the allocations listing for week 32 in year 2009
#     Then I should see an understaffed requirement for the "Bar" containing 1 employee
#     And I should see a fully staffed requirement for the "Kitchen" containing 1 employee
#     And I should see an unstaffed requirement for the "Reception" containing 1 employee
# 
#   @white
#   Scenario: Defining a new requirement
#     Given I am on the allocations listing for week 32 in year 2009
#     When I doubleclick the cell referencing the "Bar" on "8 August 2009" at "09:00"
#     Then I should see an unstaffed requirement for 1 employee at the "Bar" on "8 August 2009" from "09:00" to "10:00"
# 
#   @white
#   Scenario: Updating an existing requirement
#     Given I am on the allocations listing for week 32 in year 2009
#     When I doubleclick the requirement for the "Bar" on "8 August 2009"
#     Then I should see a requirement edit form popping up
#     When I fill in "Quantity" with "3"
#     And I select "22:00" from "End"
#     And I press "Save"
#     Then I should see an understaffed requirement for 3 employees at the "Bar" on "8 August 2009" from "17:00" to "22:00"
# 
#   @black
#   Scenario: Trying to update an existing requirement with insufficient data
#     Given I am on the allocations listing for week 32 in year 2009
#     When I doubleclick the requirement for the "Bar" on "8 August 2009"
#     Then I should see a requirement edit form popping up
#     When I fill in "Quantity" with ""
#     And I press "Save"
#     Then I should see "Requirement could not be updated."
#     And I should see "Quantity must be a number greater than 0."
#     And I should see an understaffed requirement for 2 employees at the "Bar" on "8 August 2009" from "17:00" to "23:00"
# 
#   @white
#   Scenario: Deleting an existing requirement
#     Given I am on the allocations listing for week 32 in year 2009
#     When I doubleclick the requirement for the "Bar" on "8 August 2009"
#     Then I should see a requirement edit form popping up
#     When I follow "Delete"
#     Then I should see "Requirement successfully deleted."
#     And I should not see a requirement at the "Bar" on "8 August 2009"
