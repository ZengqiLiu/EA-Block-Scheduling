Feature: Course Registration
  As a student
  I want to register for courses
  So that my selections are logged and confirmed

  Scenario: View Registration Form
    Given I am on the registration page
    Then I should see the registration form
    And I should see "Year"
    And I should see "Math Course"
    And I should see "Science Course"
    And I should see "Engineering Course"
    And I should see the "Register" button

  Scenario: Submit Registration Form
    Given I am on the registration page
    When I select "Year 1" for "Year"
    And I select "Calculus I" for "Math Course"
    And I select "Physics 1" for "Science Course"
    And I select "Eng 1" for "Engineering Course"
    And I click on the "Register" button
    Then I should see "Successfully registered!"