Feature: Adding card
  As a logged user
  Such that Im logged in
  I want to add card

Scenario: adding card with false data
    Given I am logged in into the system
    And I am on the cards pages
    And I press add card button
    And I fill in the card information incorrectly
    When I press submit
    Then I should receive a rejection message


Scenario: adding card with true data
    Given I am logged in into the system
    And I am on the cards pages
    And I press add card button
    And I fill in the card information correctly
    When I press submit
    Then I should receive a confirmation message

