Feature: Managing contacts on events

  To enable users to add and remove contacts
  I want to be able to add and remove contacts

  Scenario: Adding and removing contacts to an assessment event in new mode
    Given I am logged in as a super user
    And there is a contact event

    When I navigate to the new assessment event page and start a simple event
    And I add an existing contact
    And I click remove for that contact
    Then I should not see the contact

    When I add an existing contact
    And I add a new contact
    And I save and continue
    Then I should see all added contacts

    When I navigate to the assessment event edit page
	When I navigate to the Contacts tab
    And I check a contact to remove
    And I save and exit
    Then the removed contact should be struckthrough

  Scenario: Adding contacts to an assessment event in edit mode
    Given I am logged in as a super user
    And a morbidity event exists in Bear River with the disease African Tick Bite Fever
    And there is a contact event

    When I navigate to the morbidity event edit page
    And I add an existing contact
    And I click remove for that contact
    Then I should not see the contact

    When I add an existing contact
    And I add a new contact
    And I save and continue
    Then I should see all added contacts

  Scenario: Adding and removing contacts to a morbidity event in new mode
    Given I am logged in as a super user
    And there is a contact event

    When I navigate to the new morbidity event page and start a simple event
    And I add an existing contact
    And I click remove for that contact
    Then I should not see the contact

    When I add an existing contact
    And I add a new contact
    And I save and continue
    Then I should see all added contacts

    When I navigate to the morbidity event edit page
	When I navigate to the Contacts tab
    And I check a contact to remove
    And I save and exit
    Then the removed contact should be struckthrough

  Scenario: Adding contacts to a morbidity event in edit mode
    Given I am logged in as a super user
    And a morbidity event exists in Bear River with the disease African Tick Bite Fever
    And there is a contact event

    When I navigate to the morbidity event edit page
    And I add an existing contact
    And I click remove for that contact
    Then I should not see the contact

    When I add an existing contact
    And I add a new contact
    And I save and continue
    Then I should see all added contacts
