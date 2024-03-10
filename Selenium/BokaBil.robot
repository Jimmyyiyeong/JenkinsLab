*** Settings ***
Documentation   Test website functionality
Library     SeleniumLibrary
Resource    BokaBilResources.robot
Suite Setup     Open browser to website

*** Test Cases ***
bookCar_VG
    [Documentation]     Book car using gherkin syntax
    [Tags]      VG_TEST
    Given I'm logged in to website
    And Choose dates to book car
    When I choose car to book
    And Enter card credentials
    Then Go to My page to verify car is booked
    And Logout

Cancel booked car
    [Documentation]     Checks if car is booked. If yes, cancel booked car. If no, book car then cancel.
    [Tags]      functionalityTest
    Run Keyword    Cancel booked car

Login
    [Documentation]     Test the login/logout function
    [Tags]      functionalityTest2
    Run Keyword    I'm logged in to website
    Run Keyword    Logout

Login with incorrect password
    [Documentation]     Attempts to login with incorrect password
    [Tags]      negativeTest
    Run Keyword     incorrectPassword  ${username}    ${incorrectpassword}

Bookbutton disappears
    [Documentation]     Book button disappears when using filter
    [Tags]      negativeTest2
    Run Keyword    I'm logged in to website
    Run Keyword    Choose dates to book car
    Run Keyword    bookButtonDisappears
    Run Keyword    Logout

Input information in wrong format
    [Documentation]     Enter phonenumber in an incorrect format when creating user
    [Tags]      negativeTest3
    Given I'm at the create user page and input all information except phonenumber
    When I input the phonenumber in an incorrect format and click create
    Then I should remain on the create user page and get a prompt how to input it correctly

Choose invalid dates when booking car
    [Documentation]     invalid start and end date
    [Tags]      negativeTest4
    Run Keyword    Start and end date earlier than allowed    ${startdateoutofrange}    ${enddateoutofrange}