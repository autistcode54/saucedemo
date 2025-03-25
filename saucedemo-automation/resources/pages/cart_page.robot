*** Settings ***
Documentation     Page object for SauceDemo cart functionality.
...               This file contains keywords for interacting with the shopping cart page,
...               including verifying products, proceeding to checkout, and navigation.

Library           SeleniumLibrary
Library           String
Resource          common_variables.robot

*** Variables ***
# Core page elements
${CART_URL}              ${BASE_URL}/cart.html
${CART_ITEM}             css:.cart_item
${ITEM_NAME}             css:.inventory_item_name
${CHECKOUT_BUTTON}       css:[data-test="checkout"]
${CONTINUE_SHOPPING}     css:[data-test="continue-shopping"]
${REMOVE_BUTTON}         css:[data-test="remove-"]
${ITEM_PRICE}            css:.inventory_item_price

*** Keywords ***
Verify Cart Page Is Open
    [Documentation]     Verifies the cart page is open by checking the URL and page elements
    TRY
        Wait Until Location Is    ${CART_URL}    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://span[text()='Your Cart']
        Log    Cart page is open successfully    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify cart page is open    level=ERROR
        Fail    Cart page is not open
    END

Verify Product In Cart
    [Documentation]     Verifies a specific product is present in the cart
    [Arguments]     ${product_name}
    TRY
        Wait Until Element Is Visible    xpath://div[text()='${product_name}']    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://div[text()='${product_name}']
        Log    Product "${product_name}" is in cart    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Product "${product_name}" not found in cart    level=ERROR
        Fail    Product not found in cart
    END

Get Product Price In Cart
    [Documentation]     Gets the price of a specific product in the cart
    [Arguments]     ${product_name}
    TRY
        ${element}=    Set Variable    xpath://div[text()='${product_name}']/ancestor::div[@class='cart_item']//div[@class='inventory_item_price']
        Wait Until Element Is Visible    ${element}    timeout=${TIMEOUT}
        ${price_text}=    Get Text    ${element}
        ${price}=    Replace String    ${price_text}    $    ${EMPTY}
        Log    Product "${product_name}" price in cart is $${price}    level=INFO
        RETURN    ${price}
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to get price for product "${product_name}" in cart    level=ERROR
        Fail    Could not get product price in cart
    END

Remove Product From Cart
    [Documentation]     Removes a specific product from the cart
    [Arguments]     ${product_name}
    TRY
        ${remove_btn}=    Set Variable    xpath://div[text()='${product_name}']/ancestor::div[@class='cart_item']//button[text()='Remove']
        Wait Until Element Is Visible    ${remove_btn}    timeout=${TIMEOUT}
        Click Element    ${remove_btn}
        Log    Removed "${product_name}" from cart    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to remove product "${product_name}" from cart    level=ERROR
        Fail    Could not remove product from cart
    END

Proceed To Checkout
    [Documentation]     Clicks the checkout button to proceed with checkout
    TRY
        Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=${TIMEOUT}
        Click Element    ${CHECKOUT_BUTTON}
        Log    Proceeding to checkout    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to proceed to checkout    level=ERROR
        Fail    Could not proceed to checkout
    END

Continue Shopping
    [Documentation]     Clicks the continue shopping button to return to inventory
    TRY
        Wait Until Element Is Visible    ${CONTINUE_SHOPPING}    timeout=${TIMEOUT}
        Click Element    ${CONTINUE_SHOPPING}
        Log    Continuing shopping    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to continue shopping    level=ERROR
        Fail    Could not continue shopping
    END

Get Cart Item Count
    [Documentation]     Returns the number of items currently in the cart
    TRY
        @{items}=    Get WebElements    ${CART_ITEM}
        ${count}=    Get Length    ${items}
        Log    Cart contains ${count} items    level=INFO
        RETURN    ${count}
    EXCEPT    
        Log    No items found in cart, returning 0    level=INFO
        RETURN    0
    END

Verify Cart Is Empty
    [Documentation]     Verifies that the cart is empty
    TRY
        Page Should Not Contain Element    ${CART_ITEM}
        Log    Cart is empty as expected    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Cart is not empty    level=ERROR
        Fail    Cart should be empty but contains items
    END