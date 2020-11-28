Feature: Get available zones
  As a registered user
  Such that Im logged in and I want to park into a zone
  I want to see the real time information about the avaibality of parking space

Scenario: enter correct destination
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the form with "barcelona"
    And I press submit
    Then I should receive a table with all the available spaces and their respective distances