Feature: Booking with hourly or real time payment
  As a logged user
  Such that Im logged in and I introduce my destination
  I want to book with hourly or real time payment

Scenario: Booking with selecting hourly or real time payment
    Given I am logged in into the system
    And I am on the zones pages
    And I fill in the destination form with "barcelona"
    And I fill in the leaving time with "20:00"
    And I press submit
    And I should receive a table with all the available spaces and their respective distances
    And I click Book button and go show booking page
    And I click Book button and go zones edit page
    And I am on the zones edit page
    And I select the payment type 
    And I fill start and end date with "13:00" and "15:20"
    And I press submit
    Then I should recieve success message