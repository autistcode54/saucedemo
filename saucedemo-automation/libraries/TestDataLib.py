"""
Robot Framework library for test data management in SauceDemo automation.

This library provides Robot Framework keywords to access test data for SauceDemo tests.
It integrates with the TestDataManager to offer structured data access within Robot tests.
"""

import os
import sys
import logging
from robot.api import logger as robot_logger

# Add parent directory to system path to find utils package
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
if parent_dir not in sys.path:
    sys.path.append(parent_dir)

from utils.test_data_manager import TestDataManager


class TestDataLib:
    """Robot Framework library for test data management in SauceDemo automation."""
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_DOC_FORMAT = 'reST'
    
    def __init__(self):
        """Initialize the TestDataLib with TestDataManager instance."""
        self.data_manager = TestDataManager()
        robot_logger.info("TestDataLib initialized")
        
    def get_product_id_by_name(self, product_name):
        """
        Get product ID by name.
        
        Examples:
            | ${product_id} = | Get Product ID By Name | Sauce Labs Backpack |
        
        Args:
            product_name: Name of the product
            
        Returns:
            Product ID as a string or None if not found
        """
        product = self.data_manager.get_product_by_name(product_name)
        if product:
            return product.get('id')
        robot_logger.warn(f"Product not found: {product_name}")
        return None
        
    def get_product_price(self, product_identifier):
        """
        Get product price by name or ID.
        
        Examples:
            | ${price} = | Get Product Price | Sauce Labs Backpack |
            | ${price} = | Get Product Price | sauce-labs-backpack |
        
        Args:
            product_identifier: Product name or ID
            
        Returns:
            Product price as a number or None if not found
        """
        # Try getting by ID first
        product = self.data_manager.get_product_by_id(product_identifier)
        
        # If not found, try by name
        if not product:
            product = self.data_manager.get_product_by_name(product_identifier)
            
        if product:
            return product.get('price')
        robot_logger.warn(f"Product not found: {product_identifier}")
        return None
        
    def get_expected_sort_order(self, sort_type):
        """
        Get expected product order after sorting.
        
        Examples:
            | @{expected_order} = | Get Expected Sort Order | sort_by_name_asc |
        
        Args:
            sort_type: Type of sort (sort_by_name_asc, sort_by_name_desc, 
                       sort_by_price_asc, sort_by_price_desc)
            
        Returns:
            List of product names in expected order after sorting
        """
        return self.data_manager.get_expected_sort_order(sort_type)
        
    def product_should_be_in_department(self, product_name, department):
        """
        Verify product is in expected department.
        
        Examples:
            | Product Should Be In Department | Sauce Labs Backpack | accessories |
        
        Args:
            product_name: Name of the product
            department: Expected department name
            
        Raises:
            AssertionError: If product is not in expected department
        """
        product = self.data_manager.get_product_by_name(product_name)
        if not product:
            raise AssertionError(f"Product not found: {product_name}")
            
        actual_dept = product.get('department')
        if actual_dept != department:
            raise AssertionError(
                f"Product '{product_name}' is in department '{actual_dept}', "
                f"expected '{department}'"
            )
        return True
        
    def get_products_with_tag(self, tag):
        """
        Get list of products with specific tag.
        
        Examples:
            | @{clothing_items} = | Get Products With Tag | clothing |
        
        Args:
            tag: Tag to filter by
            
        Returns:
            List of product names with the specified tag
        """
        products = self.data_manager.get_products_by_tag(tag)
        return [p.get('name') for p in products]
        
    def get_user_expectations(self, user_type):
        """
        Get expected behaviors for user type.
        
        Examples:
            | ${user_exp} = | Get User Expectations | problem_user |
            | Log | Known issues: ${user_exp}[known_issues] |
        
        Args:
            user_type: Type of user (standard_user, locked_out_user, etc.)
            
        Returns:
            Dictionary with user expectations
        """
        return self.data_manager.get_user_expectations(user_type)
        
    def user_should_be_able_to_checkout(self, user_type):
        """
        Verify if user type should be able to checkout.
        
        Examples:
            | User Should Be Able To Checkout | standard_user |
            
        Args:
            user_type: Type of user to check
            
        Raises:
            AssertionError: If user should not be able to checkout
        """
        expectations = self.data_manager.get_user_expectations(user_type)
        if not expectations:
            raise AssertionError(f"No expectations defined for user: {user_type}")
            
        can_checkout = expectations.get('can_checkout', False)
        if not can_checkout:
            raise AssertionError(f"User '{user_type}' is not expected to be able to checkout")
        return True
        
    def get_all_product_names(self):
        """
        Get list of all product names.
        
        Examples:
            | @{all_products} = | Get All Product Names |
            
        Returns:
            List of all product names
        """
        products = self.data_manager.get_all_products()
        return [p.get('name') for p in products]
        
    def get_product_data(self, product_name, field=None):
        """
        Get product data by name.
        
        If field is provided, returns that specific field.
        Otherwise returns the entire product dictionary.
        
        Examples:
            | ${description} = | Get Product Data | Sauce Labs Backpack | description |
            | ${product} = | Get Product Data | Sauce Labs Backpack |
            
        Args:
            product_name: Name of the product
            field: (Optional) Specific field to return
            
        Returns:
            Product data as dictionary or specific field value
        """
        product = self.data_manager.get_product_by_name(product_name)
        if not product:
            robot_logger.warn(f"Product not found: {product_name}")
            return None
            
        if field:
            return product.get(field)
        return product 