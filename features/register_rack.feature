Feature: Search CD
  Scenario: Search "Pink Floyd Animals" and get "Animals"
    Given I am logged in
    And I am on rack index page
    When I fill in "search_query" with "Pink Floyd Animals"
    And I press "search"
    Then I should see "Animals"
