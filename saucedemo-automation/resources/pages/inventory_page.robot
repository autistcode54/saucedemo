*** Settings ***
Library    Collections
Library    OperatingSystem
Library    String
Library    SeleniumLibrary
Library    ../../libraries/TestDataLib.py
Resource   common_variables.robot

Documentation    Page object for SauceDemo inventory page functionality.
...              This file contains keywords for interacting with the inventory page,
...              including product browsing, sorting, filtering, and cart operations.

*** Variables ***
# Core page elements
${INVENTORY_URL}    ${BASE_URL}/inventory.html
${PRODUCT_TITLE}    css:.inventory_item_name
${ADD_TO_CART_BUTTON}    xpath://button[contains(@id,'add-to-cart-')]
${REMOVE_BUTTON}    xpath://button[contains(@id,'remove-')]
${CART_BADGE}    css:.shopping_cart_badge
${CART_LINK}    css:.shopping_cart_link
${SORT_DROPDOWN}    css:select.product_sort_container

# Sort options
${SORT_NAME_ASC}    az
${SORT_NAME_DESC}    za
${SORT_PRICE_ASC}    lohi
${SORT_PRICE_DESC}    hilo

# Data files
${PRODUCTS_JSON}    products.json

*** Keywords ***
Verify Inventory Page Is Open
    [Documentation]    Verifies that the inventory page is loaded and accessible.
    ...    Checks for the presence of product titles and validates the URL.
    TRY
        Wait Until Location Is    ${INVENTORY_URL}    timeout=${TIMEOUT}
        Page Should Contain Element    xpath://span[text()='Products']
        Log    Inventory page is open successfully    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to verify inventory page is open    level=ERROR
        Fail    Inventory page is not open
    END

Add Product To Cart
    [Documentation]    Adds a specified product to the shopping cart by name.
    ...    Converts the product name to a URL-friendly format and clicks the add button.
    [Arguments]    ${product_name}
    TRY
        ${product_id}=    Get Product ID By Name    ${product_name}
        ${button_locator}=    Set Variable    id=add-to-cart-${product_id}
        Wait Until Element Is Visible    ${button_locator}    timeout=${TIMEOUT}
        Click Element    ${button_locator}
        Log    Added "${product_name}" to cart    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to add product "${product_name}" to cart    level=ERROR
        Fail    Could not add product to cart
    END

Remove From Cart On Inventory
    [Documentation]    Removes a specified product from the shopping cart by name.
    ...    Converts the product name to a URL-friendly format and clicks the remove button.
    [Arguments]    ${product_name}
    TRY
        ${product_id}=    Get Product ID By Name    ${product_name}
        ${button_locator}=    Set Variable    id=remove-${product_id}
        Wait Until Element Is Visible    ${button_locator}    timeout=${TIMEOUT}
        Click Element    ${button_locator}
        Log    Removed "${product_name}" from cart    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to remove product "${product_name}" from cart    level=ERROR
        Fail    Could not remove product from cart
    END

Get Cart Count
    [Documentation]    Returns the current number of items in the shopping cart.
    ...    Returns 0 if the cart is empty (badge not visible).
    TRY
        ${count}=    Get Text    ${CART_BADGE}
        Log    Cart count is ${count}    level=INFO
        RETURN    ${count}
    EXCEPT
        # Badge not visible means cart is empty
        Log    Cart badge not visible, returning 0    level=INFO
        RETURN    0
    END

Open Cart
    [Documentation]    Navigates to the cart page by clicking the cart icon.
    TRY
        Wait Until Element Is Visible    ${CART_LINK}    timeout=${TIMEOUT}
        Click Element    ${CART_LINK}
        Log    Opened cart page    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to open cart page    level=ERROR
        Fail    Could not open cart
    END

Sort Products
    [Documentation]    Sorts the products according to the specified sort option.
    ...    Valid options are defined as variables: SORT_NAME_ASC, SORT_NAME_DESC, 
    ...    SORT_PRICE_ASC, SORT_PRICE_DESC
    [Arguments]    ${sort_option}
    TRY
        Wait Until Element Is Visible    ${SORT_DROPDOWN}    timeout=${TIMEOUT}
        Select From List By Value    ${SORT_DROPDOWN}    ${sort_option}
        # Allow time for sorting to complete
        Sleep    0.5s
        Log    Sorted products using option: ${sort_option}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to sort products using option: ${sort_option}    level=ERROR
        Fail    Could not sort products
    END

Sort Products By Name (A to Z)
    [Documentation]    Sorts products by name in ascending order (A to Z).
    TRY
        Sort Products    ${SORT_NAME_ASC}
        @{expected_order}=    Get Expected Sort Order    sort_by_name_asc
        Log    Expected order after sorting: ${expected_order}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to sort products by name ascending    level=ERROR
        Fail    Could not sort products by name (A to Z)
    END

Sort Products By Name (Z to A)
    [Documentation]    Sorts products by name in descending order (Z to A).
    TRY
        Sort Products    ${SORT_NAME_DESC}
        @{expected_order}=    Get Expected Sort Order    sort_by_name_desc
        Log    Expected order after sorting: ${expected_order}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to sort products by name descending    level=ERROR
        Fail    Could not sort products by name (Z to A)
    END

Sort Products By Price (Low to High)
    [Documentation]    Sorts products by price in ascending order (low to high).
    TRY
        Sort Products    ${SORT_PRICE_ASC}
        @{expected_order}=    Get Expected Sort Order    sort_by_price_asc
        Log    Expected order after sorting: ${expected_order}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to sort products by price ascending    level=ERROR
        Fail    Could not sort products by price (Low to High)
    END

Sort Products By Price (High to Low)
    [Documentation]    Sorts products by price in descending order (high to low).
    TRY
        Sort Products    ${SORT_PRICE_DESC}
        @{expected_order}=    Get Expected Sort Order    sort_by_price_desc
        Log    Expected order after sorting: ${expected_order}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to sort products by price descending    level=ERROR
        Fail    Could not sort products by price (High to Low)
    END

Verify Product Exists
    [Documentation]     Verifies a product exists on the inventory page
    [Arguments]     ${product_name}
    TRY
        Page Should Contain Element    xpath://div[text()='${product_name}']
        Log    Product "${product_name}" exists on page    level=INFO
        RETURN    ${TRUE}
    EXCEPT    
        Capture Page Screenshot
        Log    Product "${product_name}" not found on page    level=WARN
        RETURN    ${FALSE}
    END

Get Product Price
    [Documentation]     Gets the displayed price of a product from the inventory page
    [Arguments]     ${product_name}
    TRY
        ${element}=    Set Variable    xpath://div[text()='${product_name}']/ancestor::div[@class='inventory_item']//div[@class='inventory_item_price']
        Wait Until Element Is Visible    ${element}    timeout=${TIMEOUT}
        ${price_text}=    Get Text    ${element}
        ${price}=    Replace String    ${price_text}    $    ${EMPTY}
        Log    Product "${product_name}" price is $${price}    level=INFO
        RETURN    ${price}
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to get price for product "${product_name}"    level=ERROR
        Fail    Could not get product price
    END

Verify Product Price
    [Documentation]     Verifies the displayed price matches the expected price from test data
    [Arguments]     ${product_name}
    TRY
        ${expected_price}=    Get Product Price    ${product_name}
        ${displayed_price}=    Get Product Price    ${product_name}
        Should Be Equal As Numbers    ${displayed_price}    ${expected_price}
        Log    Price verification passed for "${product_name}": $${displayed_price}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Price verification failed for "${product_name}"    level=ERROR
        Fail    Product price verification failed
    END

Get All Displayed Products
    [Documentation]     Returns a list of all product names currently displayed on the page
    TRY
        @{elements}=    Get WebElements    ${PRODUCT_TITLE}
        @{product_names}=    Create List
        FOR    ${element}    IN    @{elements}
            ${name}=    Get Text    ${element}
            Append To List    ${product_names}    ${name}
        END
        Log    Found ${product_names} products on page    level=INFO
        RETURN    ${product_names}
    EXCEPT    
        Capture Page Screenshot
        Log    Failed to get displayed products    level=ERROR
        Fail    Could not get displayed products
    END

Verify Sort Order
    [Documentation]     Verifies the products are sorted in the expected order
    [Arguments]     ${sort_type}
    TRY
        @{expected_order}=    Get Expected Sort Order    ${sort_type}
        @{displayed_products}=    Get All Displayed Products
        
        # Verify first and last products match expected order
        Should Be Equal    ${displayed_products}[0]    ${expected_order}[0]
        Should Be Equal    ${displayed_products}[-1]    ${expected_order}[-1]
        
        Log    Sort order verification passed for ${sort_type}    level=INFO
    EXCEPT    
        Capture Page Screenshot
        Log    Sort order verification failed for ${sort_type}    level=ERROR
        Fail    Product sort order verification failed
    END