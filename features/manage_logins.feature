Feature: Manage logins
  Scenario: Login success
    Given I am on login page
    When I fill in "user_name" with "atsumi"
    And I fill in "user_pass" with "atsumi1031"
    And I press "login"
    Then I should be on the home page

  Scenario: Login fail
    Given I am on login page
    When I fill in "user_name" with "atsumi"
    And I fill in "user_pass" with "atsumi10311j"
    And I press "login"
    Then I should be on the login page

  Scenario: Already logged in
    Given I am logged in
    Given I am on login page
    Then I should be on the home page
