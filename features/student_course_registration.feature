Feature: Student Course Registration

  Background:
    Given I am a student on the course registration page

  Scenario: Stduent registers as 1st year student
    Given I am logged as a student on the course registration page
    When I select "1st Year" as my year
    And I select a Math course from the dropdown
    And I select a Science course from the dropdown
    And I select a Engineering course from the dropdown
    And I click on register button
    Then I should register for the courses

  Scenario: Stduent registers as 2nd year student
    Given I am logged as a student on the course registration page
    And I select "2nd Year" as my year
    And I select a Math course from the dropdown
    And I select a Science course from the dropdown
    And I select a Engineering course from the dropdown
    And I click on register button
    Then I should register for the courses


  Scenario: Student should be able to submit form with invalid data
    Given I am logged as a student on the course registration page
    When I do not select "1st year" or "2nd year"
    Then I should not be able to register for any courses