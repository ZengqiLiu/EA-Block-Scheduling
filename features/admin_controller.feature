Feature: Admin Dashboard Access

  Scenario: Admin user accesses the admin dashboard
    Given I am logged in as an admin
    When I visit the admin dashboard
    Then I should see the admin dashboard page
    And the response should be successful

  Scenario: Student user accesses the student dashboard
    Given I am logged in as a student
    When I visit the student dashboard
    Then I should see the student dashboard page
    And the response should be successful

  Scenario: User is not logged in and tries to access the dashboard
    Given I am not logged in
    When I visit the admin dashboard
    Then I should be redirected to home page
    And I should see an alert message "Login failed."