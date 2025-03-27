# SauceDemo Automation Framework

## Overview

This repository contains an end-to-end automation framework for testing the [SauceDemo](https://www.saucedemo.com/) web application. The framework is built using Robot Framework and Python, with a focus on maintainability, reusability, and data-driven testing. AI used in this project VSCode Copilot + Cursor with Deepseek r1 and Claude for debugging + Gemini 2.0. About 35 % time saved with AI.
Also for the purpose of this demo, I have used simpler security for maintaining credentials, for production, I would use some kind of encryption based on the company strategy.

## Project Structure

```
saucedemo-automation/
├── config/                  # Configuration files
│   ├── credentials.py       # User credentials and test data
│   └── test_config.ini      # Test configuration settings
├── data/                    # Test data files
│   └── products.json        # Structured product data for tests
├── libraries/               # Custom Robot Framework libraries
│   └── TestDataLib.py       # Library for test data management
├── output/                  # Test execution results
├── resources/               # Robot Framework resources
│   ├── common/              # Common utilities
│   └── pages/               # Page objects
│       ├── login_page.robot
│       ├── inventory_page.robot
│       ├── cart_page.robot
│       ├── checkout_page.robot
│       └── common_variables.robot
├── tests/                   # Test suites
│   ├── e2e/                 # End-to-end test flows
│   ├── login/               # Login-specific tests
│   └── product/             # Product-specific tests
├── utils/                   # Python utilities
│   └── test_data_manager.py # Test data management utilities
├── Dockerfile               # Container definition
├── Jenkinsfile              # CI/CD pipeline definition
├── .gitlab-ci.yml           # GitLab CI configuration
└── requirements.txt         # Python dependencies
```

## Key Features

- **Page Object Model**: Separation of test logic from page interactions
- **Structured Test Data Management**: JSON-based test data with typed access
- **Standardized Error Handling**: Consistent TRY/EXCEPT blocks with appropriate logging
- **Comprehensive Documentation**: Detailed docstrings and keyword documentation
- **CI/CD Integration**: Jenkins and GitLab CI pipeline configurations
- **Containerization**: Docker support for consistent execution environments

## Installation and Setup

### Prerequisites

- Python 3.8 or later
- Chrome browser (for UI tests)
- ChromeDriver (matching Chrome version)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/saucedemo-automation.git
   cd saucedemo-automation
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   # On Windows
   venv\Scripts\activate
   # On macOS/Linux
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Running Tests

### Basic Test Execution

Run all tests:
```bash
robot --outputdir output tests/
```

Run a specific test suite:
```bash
robot --outputdir output tests/e2e/complete_purchase.robot
```

Run tests with custom variables:
```bash
robot --outputdir output --variable BROWSER:firefox tests/
```

### Advanced Test Execution

Run tests with specific tags:
```bash
robot --outputdir output --include smoke tests/
```

Run tests with custom test data:
```bash
robot --outputdir output --variable TEST_DATA_DIR:custom_data tests/
```

## Working with Test Data

### Test Data Structure

The framework uses a structured approach to test data management, with a central `products.json` file containing all product information, test scenarios, and user expectations.

Example JSON structure:
```json
{
  "schema_version": "1.0",
  "products": [
    {
      "id": "sauce-labs-backpack",
      "name": "Sauce Labs Backpack",
      "price": 29.99,
      "description": "...",
      "department": "accessories",
      "tags": ["backpack", "bag", "accessory"]
    },
    // More products...
  ],
  "test_scenarios": {
    "sort_by_name_asc": [
      "Sauce Labs Backpack",
      // More products in expected order...
    ]
  },
  "user_expectations": {
    "standard_user": {
      "can_view_products": true,
      "can_add_to_cart": true,
      "can_checkout": true
    },
    // More user types...
  }
}
```

### Using Test Data in Robot Tests

The framework provides the `TestDataLib` Robot library for accessing test data:

```robotframework
*** Settings ***
Library    ../../libraries/TestDataLib.py

*** Test Cases ***
Verify Product Price
    ${price}=    Get Product Price    Sauce Labs Backpack
    Should Be Equal As Numbers    ${price}    29.99
    
Verify User Can Checkout
    User Should Be Able To Checkout    standard_user
    
Get Products By Category
    @{clothing_items}=    Get Products With Tag    clothing
    # Use the list of clothing items in tests...
```

### Extending Test Data

To add new products or test scenarios:

1. Update `data/products.json` with the new data
2. If needed, extend `utils/test_data_manager.py` with new methods
3. Expose the new functionality in `libraries/TestDataLib.py`

## CI/CD Integration

### Jenkins Pipeline

The project includes a Jenkinsfile that defines a pipeline with the following stages:
- Setup Python Environment
- Run E2E Tests
- Post-build actions (notifications, reports)

The pipeline is configured to run:
- Every morning at 6 AM
- Every evening at 8 PM
- On every code push to the repository

### GitLab CI

The `.gitlab-ci.yml` file defines a similar pipeline for GitLab CI.

## Docker Support

The project can be run in a Docker container for consistent execution:

```bash
docker build -t saucedemo-automation .
docker run saucedemo-automation
```

## Best Practices

The framework follows these best practices:

1. **Standardized Error Handling**: All keywords use TRY/EXCEPT blocks with consistent error handling
2. **Clear Documentation**: All files, keywords, and methods include detailed documentation
3. **Modular Design**: Page objects, test data, and test cases are separated for maintainability
4. **Consistent Naming**: Consistent naming conventions for files, keywords, and variables
5. **Typed Code**: Python code uses type hints for better code quality and IDE support

## Troubleshooting

### Common Issues

1. **ChromeDriver version mismatch**: Ensure your ChromeDriver version matches your Chrome browser version.
2. **Test data not found**: Check that the `data` directory is correctly placed and accessible.
3. **Login failures**: Verify that the credentials in `credentials.py` are correct and up-to-date.

### Logs and Reports

Test execution generates the following reports:
- `output/report.html`: HTML report with test results
- `output/log.html`: Detailed log of test execution
- `output/output.xml`: XML output for programmatic processing

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add or update tests for your changes
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Robot Framework](https://robotframework.org/) for the awesome testing framework
- [Sauce Labs](https://saucelabs.com/) for providing the demo application 
