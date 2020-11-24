Feature: User registration
  As a future user
  Such that I want to use the system
  I want to register

Scenario: register with correct data
  Given I have the name "sergi" email "fred@gmail.com" password "parool2334dd56" and license_number "12345678910"
  And I am on the registration page
  And I fill in the registration information
  When I confirm my data by pressing "submit"
  Then I should receive a register confirmation message

Scenario: register with incorrect data
  Given I have the name "sergi" email "fred" password "parool" and license_number "123456789"
  And I am on the registration page
  And I fill in the registration information
  When I confirm my data by pressing "submit"
  Then I should receive a register error message  