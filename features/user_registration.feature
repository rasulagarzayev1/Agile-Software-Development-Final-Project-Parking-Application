Feature: User registration
  As a future user
  Such that I want to use the system
  I want to register

Scenario: register with correct data
  And I am on the registration page
  And I fill in the registration information with correct data
  When I confirm my data by pressing "submit"
  Then I should receive a register confirmation message

Scenario: register with incorrect data
  And I am on the registration page
  And I fill in the registration information with incorrect data
  When I confirm my data by pressing "submit"
  Then I should receive a register error message  