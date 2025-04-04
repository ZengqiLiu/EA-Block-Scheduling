Feature: Block Selections
  As a student
  I would like to select a block of courses

  Background:
    Given the following block exist:
      | sec_name         | category     | dept_code | days | start_time | end_time   |
      | CHEM-1309-002    | Science      | CHEM      | MW   | 09:00 AM   | 10:20 AM |
      | MATH-2413-001    | Math         | MATH      | TTh  | 04:00 PM   | 05:45 PM |
      | ENGR-102-001     | Engineering  | ENGR      | MW   | 10:30 AM   | 12:20 PM |
      | CLEN-181-001     | Intro        | CLEN      | M    | 12:30 PM   | 01:20 PM |    

  Scenario: Student selects a valid block of courses
    Given I am logged in as a student 
    And I am on the blocks page
    When I select a valid block of the following courses:
      | sec_name         |
      | CHEM-1309-002    |
      | MATH-2413-001    |
      | ENGR-102-001     |
      | CLEN-181-001     |
    Then I should see a flash message "Block successfully selected."
    Then my block selection should include the following courses:
      | sec_name      |
      | CHEM-1309-002 |
      | MATH-2413-001 |
      | ENGR-102-001  |
      | CLEN-181-001  |
    And I should be remain on the blocks page