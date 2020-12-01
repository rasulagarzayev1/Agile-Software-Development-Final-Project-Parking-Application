Feature: Get available zones
  As a logged user
  Such that Im logged in and I introduce my destination
  I want to get all the information about avaible places such as price and distance

Scenario: enter correct destination
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the form with "barcelona"
    And I press submit
    Then I should receive a table with all the available spaces and their respective distances

Scenario: enter incorrect destination
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the form with "............."
    And I press submit
    Then I should receive a table with negative values