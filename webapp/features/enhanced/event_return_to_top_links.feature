Feature: Clicking a back to top link

  Scenario: Clicking a back to top link in morbidity edit mode
    Given I am logged in as a super user
    And a simple morbidity event for last name Jones
    When I am on the morbidity event edit page
      And I scroll down a bit
      And I click the back to top link
	  # TODO Jay clicking the Return to top link does not work from Selenium
	  # for some reason, and needs to be repaired
	  # The test below is commented out in the meantime
#    Then I should have been scrolled back to the top of the page
