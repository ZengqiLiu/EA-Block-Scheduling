Feature: Student Dashboard Navigation
  As a student
  I want to see a "Register" button on the dashboard
  So that I can navigate to the course registration page

  Scenario: View Register Button on Dashboard
    Given I am logged in as a student
    When I visit the student dashboard
    Then I should see the "Register" link

  Scenario: Navigate to Registration Page
    Given I am logged in as a student
    When I visit the student dashboard
    And I click on the "Register" link
    Then I should be on the registration page