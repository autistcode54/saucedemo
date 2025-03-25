"""
Test Data Manager utility for SauceDemo automation project.

This module provides a structured approach to loading and accessing test data
for the SauceDemo automation tests. It includes functions to load JSON data files,
get product information, and access test scenarios.
"""

import json
import os
import logging
from typing import Dict, List, Any, Optional, Union

# Configure logging
logging.basicConfig(level=logging.INFO, 
                   format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class TestDataManager:
    """Manages test data for the SauceDemo automation project."""
    
    def __init__(self, data_dir: str = None):
        """
        Initialize the TestDataManager.
        
        Args:
            data_dir: Directory containing test data files. If None, uses default.
        """
        if data_dir is None:
            # Get the directory of the current file
            current_dir = os.path.dirname(os.path.abspath(__file__))
            # Navigate to the data directory (parent dir's data folder)
            self.data_dir = os.path.join(os.path.dirname(current_dir), 'data')
        else:
            self.data_dir = data_dir
            
        # Cache for loaded data files
        self._cache = {}
        
        # Load products data by default
        self.products_data = self.load_json_file('products.json')
        
    def load_json_file(self, filename: str) -> Dict:
        """
        Load a JSON file from the data directory.
        
        Args:
            filename: Name of the JSON file to load
            
        Returns:
            Dictionary containing the loaded JSON data
            
        Raises:
            FileNotFoundError: If the file doesn't exist
            json.JSONDecodeError: If the file can't be parsed as JSON
        """
        if filename in self._cache:
            return self._cache[filename]
            
        file_path = os.path.join(self.data_dir, filename)
        try:
            with open(file_path, 'r') as file:
                data = json.load(file)
                self._cache[filename] = data
                logger.info(f"Successfully loaded {filename}")
                return data
        except FileNotFoundError:
            logger.error(f"File not found: {file_path}")
            raise
        except json.JSONDecodeError:
            logger.error(f"Invalid JSON in file: {file_path}")
            raise
            
    def get_product_by_id(self, product_id: str) -> Optional[Dict]:
        """
        Get product information by ID.
        
        Args:
            product_id: ID of the product to retrieve
            
        Returns:
            Dictionary containing product information or None if not found
        """
        for product in self.products_data.get('products', []):
            if product.get('id') == product_id:
                return product
        logger.warning(f"Product not found with ID: {product_id}")
        return None
        
    def get_product_by_name(self, product_name: str) -> Optional[Dict]:
        """
        Get product information by name.
        
        Args:
            product_name: Name of the product to retrieve
            
        Returns:
            Dictionary containing product information or None if not found
        """
        for product in self.products_data.get('products', []):
            if product.get('name') == product_name:
                return product
        logger.warning(f"Product not found with name: {product_name}")
        return None
        
    def get_all_products(self) -> List[Dict]:
        """
        Get all products.
        
        Returns:
            List of dictionaries containing product information
        """
        return self.products_data.get('products', [])
        
    def get_expected_sort_order(self, sort_type: str) -> List[str]:
        """
        Get expected product order after sorting.
        
        Args:
            sort_type: Type of sort (e.g., 'sort_by_name_asc')
            
        Returns:
            List of product names in expected order after sorting
        """
        return self.products_data.get('test_scenarios', {}).get(sort_type, [])
        
    def get_user_expectations(self, user_type: str) -> Dict:
        """
        Get expected behavior for a specific user type.
        
        Args:
            user_type: Type of user (e.g., 'standard_user')
            
        Returns:
            Dictionary containing expected behavior for the user
        """
        return self.products_data.get('user_expectations', {}).get(user_type, {})
        
    def get_products_by_department(self, department: str) -> List[Dict]:
        """
        Get products by department.
        
        Args:
            department: Department name (e.g., 'clothing')
            
        Returns:
            List of products in the specified department
        """
        return [p for p in self.get_all_products() if p.get('department') == department]
        
    def get_products_by_tag(self, tag: str) -> List[Dict]:
        """
        Get products by tag.
        
        Args:
            tag: Tag to search for (e.g., 'apparel')
            
        Returns:
            List of products with the specified tag
        """
        return [p for p in self.get_all_products() if tag in p.get('tags', [])]
        
    def get_schema_version(self) -> str:
        """
        Get schema version of the products data file.
        
        Returns:
            Schema version string
        """
        return self.products_data.get('schema_version', 'unknown')
        
    def get_last_updated(self) -> str:
        """
        Get last updated date of the products data file.
        
        Returns:
            Last updated date string
        """
        return self.products_data.get('last_updated', 'unknown')


# Example usage
if __name__ == "__main__":
    tdm = TestDataManager()
    print(f"Schema version: {tdm.get_schema_version()}")
    print(f"Last updated: {tdm.get_last_updated()}")
    print(f"Total products: {len(tdm.get_all_products())}")
    
    # Get a specific product
    backpack = tdm.get_product_by_id("sauce-labs-backpack")
    if backpack:
        print(f"Backpack price: ${backpack['price']}")
    
    # Get expected sort order
    print(f"Price ascending order: {tdm.get_expected_sort_order('sort_by_price_asc')}")
    
    # Get user expectations
    problem_user = tdm.get_user_expectations('problem_user')
    if problem_user:
        print(f"Problem user issues: {problem_user.get('known_issues', [])}") 