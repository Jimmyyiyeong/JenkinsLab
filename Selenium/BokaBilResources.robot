*** Settings ***
Documentation   Resourcefile for BokaBil
Library     SeleniumLibrary
Library    Collections

*** Variables ***
${websiteurl}      https://rental10.infotiv.net/
${username}     Jimmy.yiyeong@iths.se
${userpassword}     ostkaka123
${incorrectpassword}    poopiepass
${teslaroadster}   //tbody/tr[21]/td[5]/form[1]/input[4]
${cardnumber}      1234123412341234
${cardholdername}      Robot Framework
${cardmonth}   10
${cardyear}    2025
${cardcvc}     123
${startdateoutofrange}   1-03
${enddateoutofrange}     5-01
${iscaralreadybooked}

*** Keywords ***
Open browser to website
    [Documentation]     Suite setup
    [Tags]      Setup
    Open Browser    ${websiteurl}      Chrome
I'm logged in to website
    [Documentation]     Login with user credentials
    [Tags]      Login
    Input Text    //input[@id='email']    ${username}
    Input Text    //input[@id='password']    ${userpassword}
    Click Element    //button[@id='login']
    Wait Until Page Contains Element    //button[@id='mypage']
Choose dates to book car
    [Documentation]     Tests flow to book car
    [Tags]      bookCar, VG_TEST
    Click Element    //div[@id='logo']
    Input Text    //input[@id='start']  3-15
    Input Text    //input[@id='end']    3-29
    Click Element    //button[@id='continue']
I choose car to book
    [Documentation]     Get webelements, create lists, confirm car is available
    ${carmake}=    Get WebElements    //td[@class='mediumText' and text()='Tesla']
    ${carmodel}=    Get WebElements     //tr[contains(., 'Tesla')]/td[position()=2 and @class='mediumText']
    @{carsinstock}   Create List

    FOR    ${makeelement}    ${modelelement}    IN ZIP    ${carmake}    ${carmodel}
    ${make}=    Get Text    ${makeelement}
    ${model}=    Get Text    ${modelelement}
    ${car}=    Set Variable    ${make} ${model}
    Append To List    ${carsinstock}    ${car}
    END

    ${cartobook}=    Set Variable    'Tesla Roadster'
    ${iscarinstock}=    Evaluate    ${cartobook} in ${carsinstock}
    Run Keyword If    ${iscarinstock}    Book the car
Book the car
    Click Element    ${teslaroadster}
Enter card credentials
    Input Text    //input[@id='cardNum']    ${cardnumber}
    Input Text    //input[@id='fullName']    ${cardholdername}
    Select From List By Label    //select[@title='Month']       ${cardmonth}
    Select From List By Label    //select[@title='Year']        ${cardyear}
    Input Text    //input[@id='cvc']    ${cardcvc}
    Click Element    //button[@id='confirm']
    Page Should Contain Element    //div[@id='confirmMessage']
Go to My page to verify car is booked
    Click Element    //button[@id='mypage']
    Page Should Contain Element    //td[@id='startDate1']
    Page Should Contain Element    //button[@id='unBook1']
    Page Should Contain Element    //td[@id='order1']
Logout
    Click Element    //button[@id='logout']
    Page Should Contain Element    //button[@id='login']

incorrectPassword
    [Documentation]     Attempt login with incorrect credentials
    [Tags]      negativeTest
    [Arguments]     ${username}   ${incorrectpassword}
    Input Text    //input[@id='email']    ${username}
    Input Text    //input[@id='password']    ${incorrectpassword}
    Click Element    //button[@id='login']
    Element Should Be Visible    //label[@id='signInError']
    Element Should Be Visible    //button[@id='login']

bookButtonDisappears
    [Documentation]     Book button disappears when using filter
    [Tags]      negativeTest2
    ${bookbuttonexists}   Get WebElements     //input[@value='Book']
    Should Be True    ${bookbuttonexists}
    Click Element    //div[@id='ms-list-1']//button[@type='button']
    Click Element    //label[@for='ms-opt-1']
    Click Element    //div[@id='ms-list-1']//button[@type='button']
    Wait Until Element Is Not Visible    //input[@value='Book']
    ${bookbuttondoesnotexist}   Get WebElements    //input[@value='Book']
    Should Be Empty    ${bookbuttondoesnotexist}

Given I'm at the create user page and input all information except phonenumber
    [Documentation]     Enter info in an incorrect format
    [Tags]      negativeTest3
    Click Element    //button[@id='createUser']
    Input Text    //input[@id='name']    Robot
    Input Text    //input[@id='last']    Framework
    Input Text    //input[@id='emailCreate']    test@test.com
    Input Text    //input[@id='confirmEmail']    test@test.com
    Input Text    //input[@id='passwordCreate']    strongpassword123
    Input Text    //input[@id='confirmPassword']    strongpassword123
When I input the phonenumber in an incorrect format and click create
    Input Text    //input[@id='phone']    +46123123123
    Click Element    //button[@id='create']
Then I should remain on the create user page and get a prompt how to input it correctly
    Page Should Contain Element    //button[@id='create']
    Page Should Contain Element    //button[@id='cancel']

Start and end date earlier than allowed
    [Documentation]     Input invalid dates when booking car
    [Tags]      negativeTest4
    [Arguments]     ${startdateoutofrange}  ${enddateoutofrange}
    Click Element    //div[@id='logo']
    Input Text    //input[@id='start']    ${startdateoutofrange}
    Click Element    //button[@id='continue']
    Page Should Contain Element    //button[@id='continue']
    Page Should Contain Element    //button[@id='reset']
    Click Element    //button[@id='reset']
    Input Text    //input[@id='end']    ${enddateoutofrange}
    Click Element    //button[@id='continue']
    Page Should Contain Element    //button[@id='continue']
    Page Should Contain Element    //button[@id='reset']

Cancel booked car
    [Documentation]     Test function to cancel booked car
    [Tags]      functionalityTest
    Run Keyword    I'm logged in to website
    Click Element    //button[@id='mypage']
    ${iscaralreadybooked}=   Run Keyword And Return Status    Element Should Be Visible    //button[@id='unBook1']
        IF    $iscaralreadybooked == False
            Click Element    //h1[@id='title']
            Run Keyword    Choose dates to book car
            Run Keyword    I choose car to book
            Run Keyword    Enter card credentials
            Run Keyword    Go to My page to verify car is booked
        END
    Click Element    //button[@id='unBook1']
    Handle Alert
    Click Element    //button[@id='mypage']
    ${iscaralreadybooked}=   Run Keyword And Return Status    Element Should Be Visible    //button[@id='unBook1']
        IF    $iscaralreadybooked == True
            Click Element    //button[@id='unBook1']
            Handle Alert
            Click Element    //button[@id='mypage']
        END
    Page Should Not Contain Element    //td[@id='startDate1']
    Page Should Not Contain Element    //td[@id='endDate1']
    Page Should Not Contain Element    //th[normalize-space()='orderID']
    Run Keyword    Logout

#   Comments regarding deviations from the documentation/requiremements on website.
#
#   HEADER
#       "If user signs in successfully, the user information field will change to view a welcome phrase"
#       Comment: No welcome phrase, only "You are signed in as X"
#
#   CAR SELECTION
#       "There are two filter selections for sorting the list based on make and passengers. If no car meet
#       the selected filter criteria, a message asks the user to try a different selection."
#       Comment: If I sort by make, only one car and model shows up even though there are several that fit the criteria
#                that is visible on the initial list of available cars. When I clear the filter it always shows a
#                filtered list of the top most option.
#       "If a user tries to get to this page without setting any dates, an error message will appear and no cars
#       will be listed.
#       Comment: I can't get past date selection page without inputting dates. I interpret it as it would still
#                take me to the next page and show me an empty list. I guess the documentation is technically true.
#
#   CONFIRM BOOKING
#       "This form saves nothing and sends no info, it asks for a 16 digit card number, expiration date and cvc code.
#       Comment: The card number field asks for real info but any 16 digit combination works.
#
#   MY PAGE
#       "If a person attempts to reach mypage without being logged in they will be redirected back to the front page."
#       Comment: Just shows a blank page.

