Feature: Navigating directly between a CMR's children

  It's important to be able to edit related contacts and places quickly
  So, as an investigator
  I want to be able to jump between the children of a cmr w/out loading the cmr everytime

  Background:
    Given I am logged in as a super user
      And a cmr exists
      And the morbidity event has the following contacts:
        | last_name |
        | Davis     |
        | Wilson    |


  Scenario: Navigating from one sibling to another
    When I navigate to the contact named "Wilson"
     And I select "Davis" from the sibling navigator
    Then I should be on the contact named "Davis"
