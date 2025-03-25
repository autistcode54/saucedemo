*** Settings ***
Documentation     Page object for SauceDemo login functionality.
...               This file contains keywords for interacting with the login page,
...               including authentication with different user types and error handling.

Library           SeleniumLibrary
Library           String
Library           Collections
Library           OperatingSystem
Variables         ../../config/credentials.py
Library           ../../libraries/TestDataLib.py
Resource          common_variables.robot

*** Variables ***
# Core page elements
${LOGIN_URL}          ${BASE_URL}/
${USERNAME_FIELD}     css:[data-test="username"]
${PASSWORD_FIELD}     css:[data-test="password"]
${LOGIN_BUTTON}       css:[data-test="login-button"]
${ERROR_MESSAGE}      css:[data-test="error"]
${LOGIN_LOGO}         css:.login_logo

*** Keywords ***
Open Login Page
    [Documentation]    Opens the login page in a browser.
    ...    Opens the default browser, navigates to the login URL,
    ...    and verifies the page has loaded correctly.
    TRY
        Open Browser    ${LOGIN_URL}    ${BROWSER}
        Maximize Browser Window
        Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=${TIMEOUT}
        Location Should Be    ${LOGIN_URL}
        Log    Login page opened successfully    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to open login page: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not open login page: ${error}
    END

Login With Credentials
    [Documentation]    Logs in using the provided username and password.
    [Arguments]    ${username}    ${password}
    TRY
        Input Text    ${USERNAME_FIELD}    ${username}
        Input Password    ${PASSWORD_FIELD}    ${password}
        Click Element    ${LOGIN_BUTTON}
        Log    Login attempted with username: ${username}    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login with credentials: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not login with provided credentials: ${error}
    END

Login As User Type
    [Documentation]    Logs in as a specific user type defined in credentials.py.
    ...    Available user types: standard, locked, problem, performance, error, visual
    [Arguments]    ${user_type}=standard
    TRY
        Log    Logging in as user type: ${user_type}    level=INFO
        ${user_data}=    Run Keyword If    "${user_type}" == "standard_user"    Set Variable    ${standard_user}
        ...    ELSE IF    "${user_type}" == "locked_out_user"    Set Variable    ${locked_out_user}
        ...    ELSE IF    "${user_type}" == "problem_user"    Set Variable    ${problem_user}
        ...    ELSE IF    "${user_type}" == "performance_glitch_user"    Set Variable    ${performance_glitch_user}
        ...    ELSE IF    "${user_type}" == "error_user"    Set Variable    ${error_user}
        ...    ELSE IF    "${user_type}" == "visual_user"    Set Variable    ${visual_user}
        ...    ELSE    Fail    Unknown user type: ${user_type}
            
        ${username}=    Set Variable    ${user_data}[username]
        ${password}=    Set Variable    ${user_data}[password]
        
        Login With Credentials    ${username}    ${password}
        
        # Verify user expectations from test data if using TestDataLib
        ${expectations_exist}=    Run Keyword And Return Status    Get User Expectations    ${user_type}
        IF    ${expectations_exist}
            ${expectations}=    Get User Expectations    ${user_type}
            ${can_view}=    Set Variable    ${expectations}[can_view_products]
            IF    ${can_view}
                Wait Until Location Contains    inventory.html    timeout=${TIMEOUT}    message=Failed to login as ${user_type}
            END
        ELSE
            # Legacy behavior without TestDataLib
            IF    "${user_type}" != "locked_out_user"
                Wait Until Location Contains    inventory.html    timeout=${TIMEOUT}    message=Failed to login as ${user_type}
            ELSE
                Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${TIMEOUT}
            END
        END
    EXCEPT    AS    ${error}
        Log    Failed to login as ${user_type} user: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not login as ${user_type} user: ${error}
    END

Get Error Message
    [Documentation]    Retrieves the error message text from the login page.
    ...    Returns the text of the error message element if present.
    TRY
        Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${TIMEOUT}
        ${message}=    Get Text    ${ERROR_MESSAGE}
        Log    Retrieved error message: "${message}"    level=INFO
        RETURN    ${message}
    EXCEPT    AS    ${error}
        Log    Failed to get error message: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not retrieve error message: ${error}
    END

Verify Error Message
    [Documentation]    Verifies that the current error message matches the expected text.
    [Arguments]    ${expected_message}
    TRY
        ${actual_message}=    Get Error Message
        Should Be Equal    ${actual_message}    ${expected_message}
        Log    Error message verified: "${actual_message}"    level=INFO
    EXCEPT    AS    ${error}
        Log    Error message verification failed: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Error message verification failed: ${error}
    END

Login With Standard User
    [Documentation]    Logs in with standard user credentials and verifies successful login.
    ...    The standard user should be able to access the inventory page.
    TRY
        Login As User Type    standard_user
        Wait Until Location Contains    inventory.html    timeout=${TIMEOUT}    message=Failed to login as standard user
        Log    Successfully logged in as standard user    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login as standard user: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not login as standard user: ${error}
    END

Login With Locked User
    [Documentation]    Attempts login with locked out user credentials and verifies error message.
    ...    The locked user should not be able to login and should see an error message.
    TRY
        Login As User Type    locked_out_user
        Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${TIMEOUT}
        ${message}=    Get Error Message
        Should Be Equal    ${message}    ${ERROR_LOCKED_OUT}    msg=Incorrect error message for locked user
        Log    Successfully verified locked user error message    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to verify locked user error message: ${error}    level=ERROR
        Capture Page Screenshot
        Fail    Could not verify locked user error message: ${error}
    END

Login With Problem User
    [Documentation]    Logs in with problem user credentials and verifies successful login.
    ...    The problem user should be able to access the inventory page, but may have issues with functionality.
    TRY
        Login As User Type    problem
        Wait Until Location Contains    inventory.html    message=Failed to login as problem user
        Log    Successfully logged in as problem user    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login as problem user: ${error}    level=ERROR
        Capture Page Screenshot    problem_user_login_error.png
        Fail    Could not login as problem user: ${error}
    END

Login With Performance User
    [Documentation]    Logs in with performance glitch user credentials and verifies successful login.
    ...    The performance user should be able to access the inventory page, but may experience delays.
    TRY
        Login As User Type    performance
        Wait Until Location Contains    inventory.html    message=Failed to login as performance user (timeout may need to be increased)
        Log    Successfully logged in as performance user    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login as performance user: ${error}    level=ERROR
        Capture Page Screenshot    performance_user_login_error.png
        Fail    Could not login as performance user: ${error}
    END

Login With Error User
    [Documentation]    Logs in with error user credentials and verifies successful login.
    ...    The error user should be able to access the inventory page, but may encounter application errors.
    TRY
        Login As User Type    error
        Wait Until Location Contains    inventory.html    message=Failed to login as error user
        Log    Successfully logged in as error user    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login as error user: ${error}    level=ERROR
        Capture Page Screenshot    error_user_login_error.png
        Fail    Could not login as error user: ${error}
    END

Login With Visual User
    [Documentation]    Logs in with visual user credentials and verifies successful login.
    ...    The visual user should be able to access the inventory page, but may see visual defects.
    TRY
        Login As User Type    visual
        Wait Until Location Contains    inventory.html    message=Failed to login as visual user
        Log    Successfully logged in as visual user    level=INFO
    EXCEPT    AS    ${error}
        Log    Failed to login as visual user: ${error}    level=ERROR
        Capture Page Screenshot    visual_user_login_error.png
        Fail    Could not login as visual user: ${error}
    END