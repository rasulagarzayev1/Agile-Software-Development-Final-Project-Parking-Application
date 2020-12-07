
Feature: User login
  As a user
  Such that I want close my session from the system
  I want to log out

  Scenario: logout successfull
    Given I am logged in into the system
    When I press logout
    Then I should receive a logout confirmation message