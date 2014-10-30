Feature: Smaran Authentication
  Authentication system should allow valid users, and disallow invalid ones

  Background:
    Given a valid user exists

  Scenario: Login as invalid user
    Given I am on the login page
    When I fill in invalid username
    Then page should have notice message "Username is not valid"

  Scenario: Login with invalid password
    Given I am on the login page
    When I fill in invalid password
    Then page should have notice message "Password is not valid"

  Scenario: Login successfully
    Given I am on the login page
    When I fill in login credentials
    Then I should be on the home page

  Scenario: Login and change password
    Given I am on the login page
    When I fill in login credentials
      And I change the password to "pass123"
    Then page should have notice message "Successfully update profile"
      And I should be able to relogin with new password
