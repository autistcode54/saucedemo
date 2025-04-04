# SauceDemo Automation Framework

## Overview


This repository contains an end-to-end automation framework for testing the [SauceDemo](https://www.saucedemo.com/) web application. The framework is built using Robot Framework and Python, with a focus on maintainability, reusability, and data-driven testing. AI used in this project is Cursor with model Claude Sonnet 3.7. About 35 % time saved.
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

- Python 3.9 or later
- Chrome browser (for UI tests)
- ChromeDriver (matching Chrome version)
- Git (for version control)

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

4. Set up pre-commit hooks (optional but recommended):
   ```bash
   pre-commit install
   ```

### Development Tools

The project includes several development tools to maintain code quality:

- **flake8**: Python code linting
- **pre-commit**: Git hooks for automated code quality checks

These tools are automatically run on pre-commit to ensure code quality. You can also run them manually:

```bash
# Run all code quality checks
pre-commit run --all-files

# Run specific checks
flake8 .
```

### Dependencies

The project uses several key dependencies:

1. **Core Testing**:
   - Robot Framework 6.1.1
   - SeleniumLibrary 6.1.0
   - Selenium 4.13.0

2. **Browser Automation**:
   - WebDriver Manager 4.0.0
   - Chrome browser (headless mode supported)

3. **Test Data Management**:
   - JSON Schema 4.19.1
   - PyYAML 6.0.1
   - python-dotenv 1.0.0

4. **Reporting and Visualization**:
   - Robot Framework Metrics 4.0.0
   - Pabot 2.16.0 (for parallel execution)

5. **Standard Libraries**:
   - Collections Library
   - DateTime Library
   - String Library
   - SSH Library (if needed)

## Running Tests

### Basic Test Execution

Always use the `--outputdir` parameter to specify where test results should be stored:

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

Run tests with a specific browser:
```bash
robot --outputdir output --variable BROWSER:chrome tests/
```

### Common Testing Commands

Here are some common commands you might use frequently:

```bash
# Run a single end-to-end test
robot --outputdir output tests/e2e/complete_purchase.robot

# Run all login tests
robot --outputdir output tests/login/

# Run tests with the 'regression' tag
robot --outputdir output --include regression tests/

# Run tests with Chrome browser in headless mode
robot --outputdir output --variable BROWSER:headlesschrome tests/
```

### Test Artifacts

All test execution artifacts (reports, logs, screenshots) are automatically saved to the `output` directory and ignored by Git (via `.gitignore`). This prevents test artifacts from being committed to the repository.

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

1. Update `data/products.json`

## Security

### Security Features

The framework includes several security measures:

1. **Environment Variables**
   - Sensitive data is stored in `.env` files
   - Example configuration provided in `.env.example`
   - Environment files are git-ignored

2. **Data Encryption**
   - Sensitive data is encrypted at rest
   - Credit card information is encrypted
   - Encryption key stored in environment variables

3. **Secure Credentials**
   - Credentials are never hardcoded
   - Passwords are stored securely
   - Session timeout and login attempt limits

4. **Secure Development**
   - Pre-commit hooks for security checks
   - Regular dependency updates
   - Secure coding practices

### Security Best Practices

1. **Environment Setup**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   
   # Edit .env with your secure values
   # Never commit .env to version control
   ```

2. **Secure Data Handling**
   - Use environment variables for sensitive data
   - Encrypt sensitive information
   - Never log sensitive data

3. **Regular Security Updates**
   - Keep dependencies updated
   - Review security advisories
   - Update encryption keys periodically

4. **Access Control**
   - Limit access to sensitive data
   - Use secure session management
   - Implement proper error handling

### Security Checklist

<<<<<<< HEAD
- [ ] Set up environment variables
- [ ] Generate secure encryption key
- [ ] Review and update dependencies
- [ ] Configure secure session settings
- [ ] Set up proper access controls
- [ ] Implement secure error handling
- [ ] Regular security audits
=======
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
>>>>>>> 76f1e6508b53cf64b907456f6d61bb53af2f72f0
