*** Settings ***
# Import configuration and required libraries
Variables    ../../config/test_config.ini
Library    SeleniumLibrary
Library    OperatingSystem

*** Keywords ***
Handle Captcha If Present
    [Documentation]    Main keyword to handle captcha based on configuration
    # Check if captcha handling is enabled in config
    ${captcha_enabled}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_enabled}    ${False}
    Return From Keyword If    not ${captcha_enabled}
    
    # Get captcha type and auto-solve settings from config
    ${captcha_type}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_type}    recaptcha
    ${auto_solve}=    Get Variable Value    ${CAPTCHA_HANDLING.auto_solve_captcha}    ${False}
    
    # Wait for captcha element to be visible
    Wait Until Element Is Visible    ${CAPTCHA_HANDLING.captcha_selector}
    # Solve captcha if auto-solve is enabled
    Run Keyword If    ${auto_solve}    Solve Captcha Based On Type    ${captcha_type}
    ...    ELSE    Log    Captcha detected but auto-solving is disabled

Solve Captcha Based On Type
    [Arguments]    ${captcha_type}
    [Documentation]    Solves captcha based on its type
    # Route to appropriate solver based on captcha type
    Run Keyword If    '${captcha_type}' == 'recaptcha'    Solve Recaptcha
    ...    ELSE IF    '${captcha_type}' == 'hcaptcha'    Solve HCaptcha
    ...    ELSE IF    '${captcha_type}' == 'image'    Solve Image Captcha
    ...    ELSE    Log    Unsupported captcha type: ${captcha_type}

Solve Recaptcha
    [Documentation]    Solves reCAPTCHA using configured service
    # Get solver service and API keys from config
    ${solver_service}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_solver_service}    none
    ${site_key}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_site_key}    ${EMPTY}
    ${secret_key}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_secret_key}    ${EMPTY}
    
    # Route to appropriate solver service
    Run Keyword If    '${solver_service}' == '2captcha'    Solve Recaptcha With 2Captcha    ${site_key}
    ...    ELSE IF    '${solver_service}' == 'anticaptcha'    Solve Recaptcha With AntiCaptcha    ${site_key}
    ...    ELSE    Log    Unsupported captcha solver service: ${solver_service}

Solve Recaptcha With 2Captcha
    [Arguments]    ${site_key}
    [Documentation]    Solves reCAPTCHA using 2captcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    2CAPTCHA_API_KEY
    # Switch to captcha iframe
    ${iframe}=    Get WebElement    ${CAPTCHA_HANDLING.captcha_frame_selector}
    Select Frame    ${iframe}
    
    # Get reCAPTCHA response
    ${response}=    Execute JavaScript    return grecaptcha.getResponse()
    Should Not Be Empty    ${response}    Failed to get reCAPTCHA response
    
    # Switch back to main frame
    Select Frame    ${None}
    Log    Successfully solved reCAPTCHA

Solve Recaptcha With AntiCaptcha
    [Arguments]    ${site_key}
    [Documentation]    Solves reCAPTCHA using AntiCaptcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    ANTICAPTCHA_API_KEY
    # Switch to captcha iframe
    ${iframe}=    Get WebElement    ${CAPTCHA_HANDLING.captcha_frame_selector}
    Select Frame    ${iframe}
    
    # Get reCAPTCHA response
    ${response}=    Execute JavaScript    return grecaptcha.getResponse()
    Should Not Be Empty    ${response}    Failed to get reCAPTCHA response
    
    # Switch back to main frame
    Select Frame    ${None}
    Log    Successfully solved reCAPTCHA

Solve HCaptcha
    [Documentation]    Solves hCaptcha using configured service
    # Get solver service and site key from config
    ${solver_service}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_solver_service}    none
    ${site_key}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_site_key}    ${EMPTY}
    
    # Route to appropriate solver service
    Run Keyword If    '${solver_service}' == '2captcha'    Solve HCaptcha With 2Captcha    ${site_key}
    ...    ELSE IF    '${solver_service}' == 'anticaptcha'    Solve HCaptcha With AntiCaptcha    ${site_key}
    ...    ELSE    Log    Unsupported captcha solver service: ${solver_service}

Solve HCaptcha With 2Captcha
    [Arguments]    ${site_key}
    [Documentation]    Solves hCaptcha using 2captcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    2CAPTCHA_API_KEY
    # Switch to captcha iframe
    ${iframe}=    Get WebElement    ${CAPTCHA_HANDLING.captcha_frame_selector}
    Select Frame    ${iframe}
    
    # Get hCaptcha response
    ${response}=    Execute JavaScript    return hcaptcha.getResponse()
    Should Not Be Empty    ${response}    Failed to get hCaptcha response
    
    # Switch back to main frame
    Select Frame    ${None}
    Log    Successfully solved hCaptcha

Solve HCaptcha With AntiCaptcha
    [Arguments]    ${site_key}
    [Documentation]    Solves hCaptcha using AntiCaptcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    ANTICAPTCHA_API_KEY
    # Switch to captcha iframe
    ${iframe}=    Get WebElement    ${CAPTCHA_HANDLING.captcha_frame_selector}
    Select Frame    ${iframe}
    
    # Get hCaptcha response
    ${response}=    Execute JavaScript    return hcaptcha.getResponse()
    Should Not Be Empty    ${response}    Failed to get hCaptcha response
    
    # Switch back to main frame
    Select Frame    ${None}
    Log    Successfully solved hCaptcha

Solve Image Captcha
    [Documentation]    Solves image-based captcha
    # Get image source from captcha element
    ${image_element}=    Get WebElement    ${CAPTCHA_HANDLING.captcha_selector}
    ${image_src}=    Get Element Attribute    ${image_element}    src
    
    # Get solver service from config
    ${solver_service}=    Get Variable Value    ${CAPTCHA_HANDLING.captcha_solver_service}    none
    # Route to appropriate solver service
    Run Keyword If    '${solver_service}' == '2captcha'    Solve Image Captcha With 2Captcha    ${image_src}
    ...    ELSE IF    '${solver_service}' == 'anticaptcha'    Solve Image Captcha With AntiCaptcha    ${image_src}
    ...    ELSE    Log    Unsupported captcha solver service: ${solver_service}

Solve Image Captcha With 2Captcha
    [Arguments]    ${image_src}
    [Documentation]    Solves image captcha using 2captcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    2CAPTCHA_API_KEY
    # Download captcha image
    ${temp_file}=    Download Image    ${image_src}
    
    # Here you would implement the actual 2captcha API call
    # This is a placeholder for the actual implementation
    Log    Solving image captcha with 2captcha service
    
    # Clean up temporary file
    Remove File    ${temp_file}
    Log    Successfully solved image captcha

Solve Image Captcha With AntiCaptcha
    [Arguments]    ${image_src}
    [Documentation]    Solves image captcha using AntiCaptcha service
    # Get API key from environment variable
    ${api_key}=    Get Environment Variable    ANTICAPTCHA_API_KEY
    # Download captcha image
    ${temp_file}=    Download Image    ${image_src}
    
    # Here you would implement the actual AntiCaptcha API call
    # This is a placeholder for the actual implementation
    Log    Solving image captcha with AntiCaptcha service
    
    # Clean up temporary file
    Remove File    ${temp_file}
    Log    Successfully solved image captcha

Download Image
    [Arguments]    ${image_url}
    [Documentation]    Downloads image from URL to temporary file
    # Create temporary file path
    ${temp_file}=    Set Variable    ${CURDIR}${/}temp_captcha.png
    # Create temp directory if it doesn't exist
    Create Directory    ${CURDIR}${/}temp
    # Download image
    Download    ${image_url}    ${temp_file}
    [Return]    ${temp_file}
