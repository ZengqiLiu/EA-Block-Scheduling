Feature: User Management

  Background:
    Given I am logged in as an admin

  Scenario: Admin views the users index page
    Given users exist
    When I visit the users index page
    Then I should see a list of users

  Scenario: Admin views the upload element on the users index page
    Given users exist
    When I visit the users index page
    Then I should see the spreadsheet upload button

  Scenario: Admin views a user's details
    Given a user exists
    When I visit the user's show page
    Then I should see the user's details as an admin

  Scenario: Admin edits a user
    Given a user exists
    When I visit the user's edit page
    And I update the user's information
    Then I should see a success message
    And the user's information should be updated

  Scenario: Admin deletes a user
    Given a user exists
    When I delete the user
    Then I should see a confirmation message

#  Scenario: Uploading a valid spreadsheet
#    When I visit the users index page
#    And I upload a valid spreadsheet
#    Then I should see a success message saying "Users have been uploaded successfully."
#    And the users should be created
