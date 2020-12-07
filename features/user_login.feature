Feature: User login
  As a user
  Such that I go to log in
  I want to log in

Scenario: login with valid credentials
  Given I have the correct credentials to login
  And I am on the login page
  And I fill in the account information
  When I press "Login"
  Then I should receive a confirmation message

Scenario: login with invalid credentials
  Given I have the correct credentials to login
  And I am on the login page
  And I fill in the account information with incorrect data
  When I press "Login"
	Then I should receive a rejection message  
