Feature: Accounts
   I should be able to create and manage account information
   using smaran

  Background:
    Given a valid user exists

  Scenario: Login and Create an account
    Given I am on the login page
    And I fill in login credentials
    When I am on the accounts page
    And I fill in account details
    Then page should have notice message "Account was successfully created"

  Scenario: Log entries for an account
    Given I am logged in as valid user
      And An account has been created
      And I am on the account page
    When I submit new log "Hello log entry"
    Then page should have account name
      And page should have notice message "Log created."
      And page should have log "Hello log entry"
    When I delete the log entry
    Then page should have notice message "Log was deleted"
      And page should not have log entries

  Scenario: Attachments for an account
    Given I am logged in as valid user
    And a file named "attachment1.txt" with:
      """
      This is my first attachment
     """
    And An account has been created
    And I am on the account page
    When I submit new attachment "attachment1.txt"
    Then page should have notice message "Account was successfully updated."
      And page should have content "attachment1.txt" within "attachments"
      And attachment "attachment1.txt" contents should match
    When I delete the attachment "attachment1.txt"
    Then page should have notice message "Account was successfully updated."
      And page should not have any attachments

  Scenario: Max attachments for an account
    Given I am logged in as valid user
      And An account has been created
      And I am on the account page
      And I try to create maximum attachments
    When I add maximum attachments
    Then the page should have maximum attachments
    Given a file named "max_attach.txt" with:
      """
      This just won't work
     """
    When I submit new attachment "max_attach.txt"
    Then page should have notice message "Too many attachments"