*** Settings ***
Documentation     Login tests for SauceDemo
...               Verifies login functionality for different user types

Resource          ../../resources/pages/login_page.robot
Resource          ../../resources/pages/inventory_page.robot
Library           ../../libraries/TestDataLib.py

Test Teardown     Close Browser

*** Test Cases ***
Login With Standard User
    [Documentation]     Verifies that the standard user can log in successfully
    Open Login Page
    Login As User Type    standard_user
    Verify Inventory Page Is Open

Login With Locked Out User
    [Documentation]     Verifies that the locked out user cannot log in
    Open Login Page
    Login With Locked User
    ${error_msg}=    Get Error Message
    Should Be Equal    ${error_msg}    ${ERROR_LOCKED_OUT}

Login With Problem User
    [Documentation]     Verifies that the problem user can log in
    Open Login Page
    Login As User Type    problem_user
    Verify Inventory Page Is Open

Login With Performance Glitch User
    [Documentation]     Verifies login with performance glitch user
    Open Login Page
    Login As User Type    performance_glitch_user
    Verify Inventory Page Is Open

Login With Invalid Credentials
    [Documentation]     Verifies login fails with invalid credentials
    Open Login Page
    Login With Credentials    invalid_user    invalid_password
    Wait Until Element Is Visible    ${ERROR_MESSAGE}
    ${error_msg}=    Get Error Message
    Should Be Equal    ${error_msg}    ${ERROR_WRONG_CREDS}