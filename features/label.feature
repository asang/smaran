Feature: Labels

  Labels allow accounts to be grouped in the same way as folders allow files to be grouped.
  One account can belong to several labels. Similarly one label can contain several accounts

  Background:
    Given a valid user exists

  Scenario Outline: Create Label
    Given I am logged in as valid user
    And New label is "<label>" with description "<desc>"
    When I create the label
    Then I should see the "<result>"

    Scenarios: Correct labels
      | label | desc | result |
      | Label1 | Description 1 | + |
      | Label2 | Description 2 | + |

    Scenarios: No name description
      | label | desc | result |
      | Label3 | | - |
      | - | Description 4 | - |

  Scenario: Delete Label with no mapped account
    Given I am logged in as valid user
      And A label has been created
      And I am on the labels page
    When I delete the label
    Then page should have notice message "Label was removed"

  Scenario: Delete Label with mapped account
    Given I am logged in as valid user
    And A label has been created
    And An account has been created
    And Label was mapped to the account
    And I am on the labels page
    When I delete the label
    Then page should have notice message "1 error prohibited this label from being saved/updated"
    When I delete the account
    Then page should have notice message "Label was removed"
