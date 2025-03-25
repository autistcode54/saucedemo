*** Keywords ***
#-----------------------------
# Enhanced Element Interactions
#-----------------------------
Select From Dropdown By Value
    [Documentation]    Selects dropdown option by value
    [Arguments]    ${dropdown_locator}    ${value}
    Select From List By Value    ${dropdown_locator}    ${value}

Select From Dropdown By Label
    [Documentation]    Selects dropdown option by visible text
    [Arguments]    ${dropdown_locator}    ${label}
    Select From List By Label    ${dropdown_locator}    ${label}

Scroll To Element
    [Documentation]    Scrolls to element using JavaScript
    [Arguments]    ${locator}
    Execute JavaScript    document.evaluate("${locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);

Hover Over Element
    [Documentation]    Hovers over specified element
    [Arguments]    ${locator}
    Mouse Over    ${locator}

Double Click Element
    [Documentation]    Double-clicks specified element
    [Arguments]    ${locator}
    Double Click Element    ${locator}

Right Click Element
    [Documentation]    Right-clicks specified element
    [Arguments]    ${locator}
    Open Context Menu    ${locator}

Drag And Drop
    [Documentation]    Drags source element to target element
    [Arguments]    ${source_locator}    ${target_locator}
    Drag And Drop    ${source_locator}    ${target_locator}

#-----------------------------
# Enhanced Verification Methods
#-----------------------------
Verify Element Is Visible
    [Documentation]    Verifies element is visible
    [Arguments]    ${locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Element Should Be Visible    ${locator}

Verify Element Is Not Visible
    [Documentation]    Verifies element is not visible
    [Arguments]    ${locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Not Visible    ${locator}    ${timeout}

Verify Element Exists
    [Documentation]    Verifies element exists in DOM
    [Arguments]    ${locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Page Contains Element    ${locator}    ${timeout}

Verify Element Does Not Exist
    [Documentation]    Verifies element does not exist in DOM
    [Arguments]    ${locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Page Does Not Contain Element    ${locator}    ${timeout}

Verify Element Count
    [Documentation]    Verifies number of elements matching locator
    [Arguments]    ${locator}    ${expected_count}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    ${count}=    Get Element Count    ${locator}
    Should Be Equal As Numbers    ${count}    ${expected_count}

Verify Attribute Value
    [Documentation]    Verifies element attribute value
    [Arguments]    ${locator}    ${attribute}    ${expected_value}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    ${actual_value}=    Get Element Attribute    ${locator}    ${attribute}
    Should Be Equal    ${actual_value}    ${expected_value}

Verify CSS Property
    [Documentation]    Verifies element CSS property value
    [Arguments]    ${locator}    ${property}    ${expected_value}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${locator}    ${timeout}
    ${actual_value}=    Get CSS Value    ${locator}    ${property}
    Should Be Equal    ${actual_value}    ${expected_value}

#-----------------------------
# Enhanced Utility Functions
#-----------------------------
Generate Random Email
    [Documentation]    Generates random email address
    [Arguments]    ${domain}=example.com    ${prefix}=user
    ${random}=    Get Random String    8
    [Return]    ${prefix}_${random}@${domain}

Generate Random Number
    [Documentation]    Generates random number within range
    [Arguments]    ${min}=1000    ${max}=9999
    ${number}=    Evaluate    random.randint(${min}, ${max})    random
    [Return]    ${number}

Create Test File
    [Documentation]    Creates a test file with specified content
    [Arguments]    ${file_path}    ${content}=${EMPTY}
    Create File    ${file_path}    ${content}

Delete Test File
    [Documentation]    Deletes a test file
    [Arguments]    ${file_path}
    Remove File    ${file_path}

Get Page Title
    [Documentation]    Returns current page title
    ${title}=    Get Title
    [Return]    ${title}

Verify Page Title
    [Documentation]    Verifies page title matches expected value
    [Arguments]    ${expected_title}
    ${actual_title}=    Get Page Title
    Should Be Equal    ${actual_title}    ${expected_title}

Verify Page URL
    [Documentation]    Verifies current URL matches expected value
    [Arguments]    ${expected_url}
    ${actual_url}=    Get Location
    Should Be Equal    ${actual_url}    ${expected_url}

Switch To Frame
    [Documentation]    Switches to specified frame
    [Arguments]    ${frame_locator}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Element Is Visible    ${frame_locator}    ${timeout}
    Select Frame    ${frame_locator}

Switch To Default Content
    [Documentation]    Returns to main document
    Unselect Frame

Switch To Window By Title
    [Documentation]    Switches to browser window by title
    [Arguments]    ${expected_title}
    Switch Browser    ${expected_title}

Close Current Window
    [Documentation]    Closes current browser window/tab
    Close Window

Get Cookie Value
    [Documentation]    Gets value of specified cookie
    [Arguments]    ${cookie_name}
    ${cookie}=    Get Cookie    ${cookie_name}
    [Return]    ${cookie.value}

Add Cookie
    [Documentation]    Adds a cookie to browser
    [Arguments]    ${name}    ${value}
    Add Cookie    ${name}    ${value}

Execute JavaScript On Element
    [Documentation]    Executes JavaScript on specified element
    [Arguments]    ${locator}    ${script}
    Execute JavaScript    arguments[0].${script}    ARGUMENTS    ${locator}

Retry Keyword
    [Documentation]    Retries a keyword until success or timeout
    [Arguments]    ${keyword}    ${timeout}=${LONG_TIMEOUT}    ${interval}=1s
    Wait Until Keyword Succeeds    ${timeout}    ${interval}    ${keyword}
