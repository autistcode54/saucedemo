*** Settings ***
Documentation     Product data validation tests for SauceDemo
...               Demonstrates structured test data management and validation
...               of product information across the application.

Resource          ../../resources/pages/login_page.robot
Resource          ../../resources/pages/inventory_page.robot
Resource          ../../resources/pages/cart_page.robot
Resource          ../../resources/pages/checkout_page.robot
Library           ../../libraries/TestDataLib.py

Test Setup        Begin Test
Test Teardown     End Test

*** Variables ***
${BROWSER}        chrome
${TEST_USER}      standard_user

*** Test Cases ***
Validate All Products Match Expected Data
    [Documentation]     Verifies that all products on the inventory page
    ...                 match expected data in terms of names and prices.
    
    # Get all expected product names from test data
    @{all_products}=    Get All Product Names
    Log    Validating ${all_products} products    level=INFO
    
    # Verify that each product exists and has correct price
    FOR    ${product_name}    IN    @{all_products}
        Verify Product Exists    ${product_name}
        Verify Product Price     ${product_name}
    END
    
    # Validate number of products
    @{displayed_products}=    Get All Displayed Products
    ${expected_count}=    Get Length    ${all_products}
    ${actual_count}=      Get Length    ${displayed_products}
    Should Be Equal As Integers    ${actual_count}    ${expected_count}

Verify Product Sorting Works Correctly
    [Documentation]     Verifies that product sorting functions as expected
    ...                 for all sort options, matching expected sort orders.
    
    # Test name sorting (A to Z)
    Sort Products By Name (A to Z)
    Verify Sort Order    sort_by_name_asc
    
    # Test name sorting (Z to A)
    Sort Products By Name (Z to A)
    Verify Sort Order    sort_by_name_desc
    
    # Test price sorting (Low to High)
    Sort Products By Price (Low to High)
    Verify Sort Order    sort_by_price_asc
    
    # Test price sorting (High to Low)
    Sort Products By Price (High to Low)
    Verify Sort Order    sort_by_price_desc

Verify Specific Product Details
    [Documentation]     Verifies detailed information for a specific product.
    
    # Get complete data for a product
    ${backpack_data}=    Get Product Data    Sauce Labs Backpack
    
    # Verify displayed data matches expected data
    Verify Product Exists    Sauce Labs Backpack
    
    # Get price from UI and compare with test data
    ${ui_price}=    Get Product Price    Sauce Labs Backpack
    ${expected_price}=    Convert To String    ${backpack_data}[price]
    Should Be Equal    ${ui_price}    ${expected_price}
    
    # Add product to cart
    Add Product To Cart    Sauce Labs Backpack
    ${cart_count}=    Get Cart Count
    Should Be Equal As Integers    ${cart_count}    1
    
    # Remove product from cart
    inventory_page.Remove From Cart On Inventory    Sauce Labs Backpack
    ${cart_count}=    Get Cart Count
    Should Be Equal As Integers    ${cart_count}    0

Validate Products By Department
    [Documentation]     Demonstrates filtering and validating products by department.
    
    # Get all clothing items
    @{clothing_items}=    Get Products With Tag    clothing
    
    # Verify all clothing items exist on the page
    FOR    ${product_name}    IN    @{clothing_items}
        Verify Product Exists    ${product_name}
        Product Should Be In Department    ${product_name}    clothing
    END
    
    # Get all accessories
    @{accessories}=    Get Products With Tag    accessory
    
    # Verify all accessories exist on the page
    FOR    ${product_name}    IN    @{accessories}
        Verify Product Exists    ${product_name}
        Product Should Be In Department    ${product_name}    accessories
    END

*** Keywords ***
Begin Test
    [Documentation]     Common setup for all test cases
    Open Login Page
    Login As User Type    ${TEST_USER}
    Verify Inventory Page Is Open

End Test
    [Documentation]     Common teardown for all test cases
    Close Browser 