Feature: Submit a start and end of parking time
  As a logged user
  Such that Im logged in and I introduce my destination
  I want to book with hourly or real time payment

Scenario: Submit a start and end of parking time
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
    And I select real payment type
    And I fill start and end date with "13:00" and "13:35"
    And I press submit2
    Then I should recieve success message