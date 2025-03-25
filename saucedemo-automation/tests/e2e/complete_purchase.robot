*** Settings ***
Documentation     Complete Purchase End-to-End Test
...               Tests the full purchase flow from login to checkout completion
...               using structured test data.

Resource          ../../resources/pages/login_page.robot
Resource          ../../resources/pages/inventory_page.robot
Resource          ../../resources/pages/cart_page.robot
Resource          ../../resources/pages/checkout_page.robot
Library           ../../libraries/TestDataLib.py

Test Setup        Begin Test
Test Teardown     End Test

*** Variables ***
${TEST_USER}      standard_user
${TEST_PRODUCT}   Sauce Labs Backpack

*** Test Cases ***
Complete Purchase Happy Path
    [Documentation]    Tests the complete purchase flow from product selection to checkout
    
    # Verify user expectations from test data
    ${user_expectations}=    Get User Expectations    ${TEST_USER}
    Log    Testing with user: ${TEST_USER}    level=INFO
    User Should Be Able To Checkout    ${TEST_USER}
    
    # Get product data for test
    ${product}=    Get Product Data    ${TEST_PRODUCT}
    Log    Testing with product: ${TEST_PRODUCT} ($${product}[price])    level=INFO
    
    # Add product to cart
    Add Product To Cart    ${TEST_PRODUCT}
    ${cart_count}=    Get Cart Count
    Should Be Equal As Integers    ${cart_count}    1
    
    # Open cart and verify product
    Open Cart
    Verify Product In Cart    ${TEST_PRODUCT}
    
    # Proceed to checkout
    Proceed To Checkout
    
    # Fill checkout information
    Fill Checkout Information    John    Doe    12345
    Continue To Overview
    
    # Verify product and price in checkout overview
    Verify Product In Overview    ${TEST_PRODUCT}
    ${expected_price}=    Convert To String    ${product}[price]
    Verify Product Price In Overview    ${TEST_PRODUCT}    ${expected_price}
    
    # Complete purchase
    Finish Checkout
    
    # Verify order completion
    Verify Order Complete
    Back Home

*** Keywords ***
Begin Test
    [Documentation]    Test setup - opens the browser and logs in
    Open Login Page
    Login As User Type    ${TEST_USER}
    Verify Inventory Page Is Open

End Test
    [Documentation]    Test teardown - closes the browser
    Close Browser 