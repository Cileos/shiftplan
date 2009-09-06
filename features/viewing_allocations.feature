# @allocations
# Feature: Viewing allocations
#   In order to be able to see when my employees are working where
#   As a shift manager
#   I want to be able to view allocations
# 
#   Background:
#     Given the following allocations:
#      | employee         | workplace | start           | end             |
#      | Sven Fuchs       | Bar       | 2009-7-8 17:00  | 2009-7-8 23:00  |
#      | Ines Kozlowski   | Reception | 2009-8-7 17:00  | 2009-8-7 23:00  |
#      | Fritz Thielemann | Bar       | 2009-8-8 17:00  | 2009-8-8 23:00  |
#      | Clemens Kofler   | Kitchen   | 2009-8-8 16:00  | 2009-8-8 22:00  |
#      | Laura Kozlowski  | Bar       | 2009-8-12 17:00 | 2009-8-12 23:00 |
# 
#   @white
#   Scenario: Showing all allocations for a given week
#     When I go to the allocations listing for week 32 in year 2009
#     Then I should see "Fritz Thielemann"
#     And I should see "Clemens Kofler"
#     And I should see "Ines Kozlowski"
#     And I should not see "Laura Kozlowski"
#     And I should not see "Sven Fuchs"
# 
#   @white
#   Scenario: Showing all allocations for a given day
#     When I go to the allocations listing for 8 August 2009
#     Then I should see "Fritz Thielemann"
#     And I should see "Clemens Kofler"
#     And I should not see "Ines Kozlowski"
#     And I should not see "Laura Kozlowski"
#     And I should not see "Sven Fuchs"
# 
#   @white
#   Scenario: Showing all allocations for a given month
#     When I go to the allocations listing for August 2009
#     Then I should see "Fritz Thielemann"
#     And I should see "Clemens Kofler"
#     And I should see "Ines Kozlowski"
#     And I should see "Laura Kozlowski"
#     And I should not see "Sven Fuchs"
