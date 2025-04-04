Feature: Block Management
  As an administrator
  I want to manage course blocks
  So that I can organize courses effectively

  Background:
    Given I am logged in as a test user
    And the following courses exist:
      | sec_name     | category | days | start_time | end_time  |
      | MATH-101-001 | Math    | MW   | 9:00 AM    | 10:20 AM  |
      | PHYS-101-001 | Science | MW   | 10:30 AM   | 11:50 AM  |

  Scenario: Preview shows blocks after generation
    When I visit the blocks page
    And I click the generate blocks button
    And I visit the preview page
    Then I should see "PREVIEW GENERATED BLOCKS"
    And I should see preview controls