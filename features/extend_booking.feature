Feature: Extend parking period
  As a logged user
  Such that Im logged in and I introduce my destination
  I want to book with hourly or real time payment

Scenario: Extend parking period
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the destination form with "Puiestee 112"
    And I fill in the leaving time with "20:00"
    And I press submit1
    And I should receive a table with all the available spaces and their respective distances
    And I click goShowDetail button and go show booking page
    And I click add button and go zones edit page
    And I am on the zones edit page
    And I click the payment type
    And I select hourly payment type
    And I fill start and end date with "13:00" and "15:20"
    And I press submit2
    And I am on the bookings page
    And I click extend button
    And I fill end date with "16:30"
    And I press submit2
    Then I should recieve success message1