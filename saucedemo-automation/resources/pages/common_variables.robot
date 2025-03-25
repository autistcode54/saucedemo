*** Settings ***
Documentation     Common variables shared across all page objects
...               Defines timeouts, URL parts, and common locators.

*** Variables ***
# Timeout settings
${TIMEOUT}             10
${RETRY_INTERVAL}      0.5

# Browser settings
${BROWSER}             chrome

# Base URLs
${BASE_URL}            https://www.saucedemo.com
${LOGIN_URL}           ${BASE_URL}/
${INVENTORY_URL}       ${BASE_URL}/inventory.html
${CART_URL}            ${BASE_URL}/cart.html
${CHECKOUT_STEP_ONE}   ${BASE_URL}/checkout-step-one.html
${CHECKOUT_STEP_TWO}   ${BASE_URL}/checkout-step-two.html
${CHECKOUT_COMPLETE}   ${BASE_URL}/checkout-complete.html

# Common error messages
${ERROR_LOCKED_OUT}    Epic sadface: Sorry, this user has been locked out.
${ERROR_WRONG_CREDS}   Epic sadface: Username and password do not match any user in this service
${ERROR_MISSING_CREDS}    Epic sadface: Username is required
${ERROR_MISSING_USERNAME}    Epic sadface: Username is required
${ERROR_MISSING_PASSWORD}    Epic sadface: Password is required
${ERROR_MISSING_FIRST_NAME}    Error: First Name is required
${ERROR_MISSING_LAST_NAME}    Error: Last Name is required
${ERROR_MISSING_POSTAL_CODE}    Error: Postal Code is required
