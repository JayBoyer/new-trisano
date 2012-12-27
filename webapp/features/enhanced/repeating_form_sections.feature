Feature: Morbidity event form core view configs

  To allow for a more relevant event form
  An investigator should see core view configs on a moridity form

  Scenario: Morbidity event repeating sections
    Given   I am logged in as a super user
    And     a morbidity event form exists
    And     that form has a repeating section configured in the default view with a question
    And     that form is published
    And     a morbidity event exists with a disease that matches the form

    When    I am on the morbidity event edit page
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the assessment event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions


  Scenario: Assessment event repeating sections
    Given   I am logged in as a super user
    And     a assessment event form exists
    And     that form has a repeating section configured in the default view with a question
    And     that form is published
    And     a assessment event exists with a disease that matches the form

    When    I am on the assessment event edit page
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the assessment event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions


  Scenario: Contact event repeating sections
    Given   I am logged in as a super user
    And     a contact event form exists
    And     that form has a repeating section configured in the default view with a question
    And     that form is published
    And     a contact event exists with a disease that matches the form

    When    I am on the contact event edit page
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I print the contact event
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions


  Scenario: Place event repeating sections
    Given   I am logged in as a super user
    And     a place event form exists
    And     that form has a repeating section configured in the default view with a question
    And     that form is published
    And     a place event exists with a disease that matches the form

    When    I am on the place event edit page
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions


  Scenario: Encounter event repeating sections
    Given   I am logged in as a super user
    And     a encounter event form exists
    And     that form has a repeating section configured in the default view with a question
    And     that form is published
    And     a encounter event exists with a disease that matches the form

    When    I am on the encounter event edit page
    And     I create 1 new instances of all section repeaters
    Then    I should see 2 instances of the repeater section questions

    When    I answer 2 instances of all repeater section questions
    And     I save and continue
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions

    When    I save and exit
    Then    I should see "successfully updated"
    And     I should see 2 instances of the repeater section questions
    And     I should see 2 instances of answers to the repeating section questions