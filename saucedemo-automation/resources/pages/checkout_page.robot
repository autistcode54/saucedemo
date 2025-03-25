*** Settings ***
Documentation     Page object for SauceDemo checkout functionality.
...               This file contains keywords for interacting with the checkout pages,
...               including information entry, overview verification, and order completion.

Library           SeleniumLibrary
Library           String
Library           ../../libraries/TestDataLib.py
Resource          common_variables.robot

*** Variables ***
# Checkout Step One
${CHECKOUT_STEP_ONE_URL}       ${BASE_URL}/checkout-step-one.html
${FIRST_NAME_FIELD}            css:[data-test="firstName"]
${LAST_NAME_FIELD}             css:[data-test="lastName"]
${POSTAL_CODE_FIELD}           css:[data-test="postalCode"]
${CONTINUE_BUTTON}             css:[data-test="continue"]
${CANCEL_BUTTON}               css:[data-test="cancel"]
${ERROR_MESSAGE}               css:[data-test="error"]

# Checkout Step Two
${CHECKOUT_STEP_TWO_URL}       ${BASE_URL}/checkout-step-two.html
${CHECKOUT_OVERVIEW}           css:.checkout_summary_container
${FINISH_BUTTON}               css:[data-test="finish"]
${CANCEL_BUTTON_STEP_TWO}      css:[data-test="cancel"]

# Checkout Complete
${CHECKOUT_COMPLETE_URL}       ${BASE_URL}/checkout-complete.html
${BACK_HOME_BUTTON}            css:[data-test="back-to-products"]
${COMPLETE_HEADER}             css:.complete-header
${COMPLETE_TEXT}               css:.complete-text
${COMPLETE_IMAGE}              css:.pony_express

*** Keywords ***
Verify Checkout Step One Page Is Open
    [Documentation]     Verifies the checkout step one page is open
    TRY
        Wait Until Location Is    ${CHECKOUT_STEP_ONE_URL}    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://span[text()='Checkout: Your Information']
        Log    Checkout step one page is open successfully    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify checkout step one page is open    level=ERROR
        Fail    Checkout step one page is not open
    END

Verify Checkout Page Is Open
    [Documentation]     Verifies the checkout page is open (alias for step one)
    Verify Checkout Step One Page Is Open

Fill Checkout Information
    [Documentation]     Fills out the checkout information form
    [Arguments]     ${first_name}    ${last_name}    ${postal_code}
    TRY
        Wait Until Element Is Visible    ${FIRST_NAME_FIELD}    timeout=${TIMEOUT}
        Input Text    ${FIRST_NAME_FIELD}    ${first_name}
        Input Text    ${LAST_NAME_FIELD}    ${last_name}
        Input Text    ${POSTAL_CODE_FIELD}    ${postal_code}
        Log    Filled checkout information: ${first_name} ${last_name}, ${postal_code}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to fill checkout information    level=ERROR
        Fail    Could not fill checkout information
    END

Continue To Overview
    [Documentation]     Clicks the continue button to proceed to checkout overview
    TRY
        Wait Until Element Is Visible    ${CONTINUE_BUTTON}    timeout=${TIMEOUT}
        Click Element    ${CONTINUE_BUTTON}
        
        # Check for error messages before proceeding
        ${error_visible}=    Run Keyword And Return Status    
        ...    Page Should Contain Element    ${ERROR_MESSAGE}    
        
        IF    ${error_visible}
            ${error_text}=    Get Error Message
            Log    Error encountered: ${error_text}    level=WARN
            Fail    Could not continue to overview: ${error_text}
        END
        
        Wait Until Location Is    ${CHECKOUT_STEP_TWO_URL}    timeout=${TIMEOUT}
        Log    Continued to checkout overview successfully    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to continue to checkout overview    level=ERROR
        Fail    Could not continue to checkout overview
    END

Get Error Message
    [Documentation]     Gets the error message from the checkout page
    TRY
        Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${TIMEOUT}
        ${message}=    Get Text    ${ERROR_MESSAGE}
        Log    Error message: ${message}    level=INFO
        RETURN    ${message}
    EXCEPT    
        Log    No error message found    level=WARN
        RETURN    ${EMPTY}
    END

Cancel Checkout
    [Documentation]     Clicks the cancel button to return to the cart
    TRY
        Wait Until Element Is Visible    ${CANCEL_BUTTON}    timeout=${TIMEOUT}
        Click Element    ${CANCEL_BUTTON}
        Wait Until Location Is    ${CART_URL}    timeout=${TIMEOUT}
        Log    Checkout cancelled, returned to cart    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to cancel checkout    level=ERROR
        Fail    Could not cancel checkout
    END

Verify Checkout Overview
    [Documentation]     Verifies the checkout overview page is displayed
    TRY
        Wait Until Location Is    ${CHECKOUT_STEP_TWO_URL}    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://span[text()='Checkout: Overview']
        Wait Until Element Is Visible    ${CHECKOUT_OVERVIEW}    timeout=${TIMEOUT}
        Log    Checkout overview page verified    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify checkout overview page    level=ERROR
        Fail    Checkout overview page verification failed
    END

Verify Product In Overview
    [Documentation]     Verifies a specific product is present in the checkout overview
    [Arguments]     ${product_name}
    TRY
        Wait Until Element Is Visible    xpath://div[text()='${product_name}']    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://div[text()='${product_name}']
        Log    Product "${product_name}" is in checkout overview    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Product "${product_name}" not found in checkout overview    level=ERROR
        Fail    Product not found in checkout overview
    END

Verify Product Price In Overview
    [Documentation]     Verifies the price of a product in the checkout overview
    [Arguments]     ${product_name}    ${expected_price}
    TRY
        ${element}=    Set Variable    xpath://div[text()='${product_name}']/ancestor::div[contains(@class,'cart_item')]//div[@class='inventory_item_price']
        Wait Until Element Is Visible    ${element}    timeout=${TIMEOUT}
        ${price_text}=    Get Text    ${element}
        ${price}=    Replace String    ${price_text}    $    ${EMPTY}
        Should Be Equal As Strings    ${price}    ${expected_price}
        Log    Product "${product_name}" price verified: $${price}    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify price for product "${product_name}" in overview    level=ERROR
        Fail    Product price verification failed
    END

Finish Checkout
    [Documentation]     Clicks the finish button to complete the purchase
    TRY
        Wait Until Element Is Visible    ${FINISH_BUTTON}    timeout=${TIMEOUT}
        Click Element    ${FINISH_BUTTON}
        Wait Until Location Is    ${CHECKOUT_COMPLETE_URL}    timeout=${TIMEOUT}
        Log    Checkout completed successfully    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to finish checkout    level=ERROR
        Fail    Could not finish checkout
    END

Verify Order Complete
    [Documentation]     Verifies the order completion page is displayed with success message
    TRY
        Wait Until Location Is    ${CHECKOUT_COMPLETE_URL}    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://span[text()='Checkout: Complete!']
        Page Should Contain Element    ${COMPLETE_HEADER}
        Page Should Contain Element    ${COMPLETE_TEXT}
        Page Should Contain Element    ${COMPLETE_IMAGE}
        
        ${header}=    Get Text    ${COMPLETE_HEADER}
        Should Contain    ${header}    THANK YOU    ignore_case=True
        
        Log    Order completion verified: "${header}"    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify order completion    level=ERROR
        Fail    Order completion verification failed
    END

Back Home
    [Documentation]     Clicks the back home button to return to inventory
    TRY
        Wait Until Element Is Visible    ${BACK_HOME_BUTTON}    timeout=${TIMEOUT}
        Click Element    ${BACK_HOME_BUTTON}
        Wait Until Location Is    ${INVENTORY_URL}    timeout=${TIMEOUT}
        Log    Returned to home page    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to return to home page    level=ERROR
        Fail    Could not return to home page
    END