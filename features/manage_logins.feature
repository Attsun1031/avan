Feature: Manage logins
  Scenario: Login success
    Given I am on login page
    When I fill in "user_name" with "atsumi"
    And I fill in "user_pass" with "atsumi1031"
    And I press "ログイン"
    Then I should be on the home page

  Scenario: Login fail
    Given I am on login page
    When I fill in "user_name" with "atsumi"
    And I fill in "user_pass" with "atsumi10311j"
    And I press "ログイン"
    Then I should be on the login page

  Scenario: Already logged in
    Given I am logged in
    And I am on login page
    Then I should be on the home page

  Scenario: Require login
    Given I am on rack index page
    Then I should be on the login page
    When I log in
    Then I should be on the rack index page
