"""
Credentials and test data for SauceDemo automation.

This module provides structured access to login credentials
and other test data needed for SauceDemo tests.
"""

# Dictionary of user credentials by type
credentials = {
    "standard": "standard_user:secret_sauce",
    "locked": "locked_out_user:secret_sauce",
    "problem": "problem_user:secret_sauce",
    "performance": "performance_glitch_user:secret_sauce",
    "error": "error_user:secret_sauce",
    "visual": "visual_user:secret_sauce"
}

# Pre-formatted credentials for direct login
standard_user = {
    "username": "standard_user",
    "password": "secret_sauce"
}

locked_out_user = {
    "username": "locked_out_user",
    "password": "secret_sauce"
}

problem_user = {
    "username": "problem_user",
    "password": "secret_sauce"
}

performance_glitch_user = {
    "username": "performance_glitch_user",
    "password": "secret_sauce"
}

error_user = {
    "username": "error_user",
    "password": "secret_sauce"
}

visual_user = {
    "username": "visual_user",
    "password": "secret_sauce"
}

# Test data for form filling
test_data = {
    "first_name": "John",
    "last_name": "Doe",
    "postal_code": "12345",
    "credit_card": {
        "number": "4111111111111111",
        "expiry": "12/25",
        "cvv": "123"
    }
}

# Dictionary of expected error messages
error_messages = {
    "empty_username": "Epic sadface: Username is required",
    "empty_password": "Epic sadface: Password is required",
    "invalid_credentials": "Epic sadface: Username and password do not match any user in this service",
    "locked_out": "Epic sadface: Sorry, this user has been locked out.",
    "empty_firstname": "Error: First Name is required",
    "empty_lastname": "Error: Last Name is required",
    "empty_postal": "Error: Postal Code is required"
}