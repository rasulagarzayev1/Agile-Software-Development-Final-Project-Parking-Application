Feature: Adding balance
  As a logged user
  Such that Im logged in
  I want to add balance

Scenario: having no added card
    Given I am logged in into the system
    And I am on the users pages
    And I press show button
    And I press add balance button
    And I fill in the form with "12.34"
    When I press submit
    Then I should receive a rejection message

Scenario: having added card
    Given I am logged in into the system
    And I am on the cards pages
    And I press add card button
    And I fill in the card information
    When I press submit1
    Then I should receive a confirmation message
    And I am on the users pages
    And I press show button
    And I press add balance button
    And I fill in the form with "12.34"
    When I press submit
    Then I should receive a confirmation message about increased balance