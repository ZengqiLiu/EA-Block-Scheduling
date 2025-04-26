Feature: Student Course Registration
  As a student
  I want to register for courses and have my prerequisites validated

  Background:
    Given the following registration courses exist abc:
      | dept_code | sec_name       | short_title            |
      | MATH      | MATH-2412-001   | Pre-Calculus            |
      | CHEM      | CHEM-1309-001   | General Chemistry I     |
      | ENGR      | ENGR-102-001    | Introduction to Engr    |
    And I am on the registration page abc

  Scenario: Successfully register for courses abc
    When I select "N/A" for "Math Course" abc
    And I select "N/A" for "Science Course" abc
    And I select "N/A" for "Engineering Course" abc
    And I select "MATH-2412" for "Wanted Math Course" abc
    And I select "CHEM-1309" for "Wanted Science Course" abc
    And I select "ENGR-102" for "Wanted Engineering Course" abc
    And I click on the "Register" button abc
    Then I should be redirected to the blocks page abc