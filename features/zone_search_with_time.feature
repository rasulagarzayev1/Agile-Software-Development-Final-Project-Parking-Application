Feature: Get available zones
  As a logged user
  Such that Im logged in and I introduce my destination and my leaving time
  I want to get all the information about available places such as total and distance
Scenario: enter correct destination and correct time
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the form with "Tahtvere 48"
    And I fill in the leaving time with "23:59"
    And I press submit
    Then I should receive a table with all the available spaces and their respective distances and prices
