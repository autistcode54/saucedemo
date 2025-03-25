*** Settings ***
# Import configuration and required libraries
Variables    ../../config/test_config.ini
Library    SeleniumLibrary
Library    OperatingSystem

*** Keywords ***
Handle Popup If Present
    [Documentation]    Main keyword to handle popups based on configuration
    # Check if popup handling is enabled in config
    ${handle_popups}=    Get Variable Value    ${POPUP_HANDLING.handle_popups}    ${True}
    Return From Keyword If    not ${handle_popups}
    
    # Get popup timeout and selector from config
    ${popup_timeout}=    Get Variable Value    ${POPUP_HANDLING.popup_timeout}    5
    ${popup_selector}=    Get Variable Value    ${POPUP_HANDLING.popup_selector}    css=.modal-content
    
    # Wait for popup to be visible
    Wait Until Element Is Visible    ${popup_selector}    ${popup_timeout}
    # Determine popup type and handle accordingly
    ${popup_type}=    Get Popup Type
    Handle Popup By Type    ${popup_type}

Get Popup Type
    [Documentation]    Determines the type of popup based on whitelist and blacklist
    # Get whitelist and blacklist from config
    ${whitelist}=    Get Variable Value    ${POPUP_HANDLING.popup_whitelist}    ${EMPTY}
    ${blacklist}=    Get Variable Value    ${POPUP_HANDLING.popup_blacklist}    ${EMPTY}
    
    # Get popup text for classification
    ${popup_text}=    Get Text    ${POPUP_HANDLING.popup_selector}
    # Classify popup based on lists
    Return From Keyword If    '${popup_text}' in '${whitelist}'    whitelisted
    Return From Keyword If    '${popup_text}' in '${blacklist}'    blacklisted
    [Return]    unknown

Handle Popup By Type
    [Arguments]    ${popup_type}
    [Documentation]    Routes popup handling based on its type
    # Handle popup based on classification
    Run Keyword If    '${popup_type}' == 'whitelisted'    Handle Whitelisted Popup
    ...    ELSE IF    '${popup_type}' == 'blacklisted'    Handle Blacklisted Popup
    ...    ELSE    Handle Unknown Popup

Handle Whitelisted Popup
    [Documentation]    Handles whitelisted popups (e.g., cookie consent, newsletter)
    # Get auto-accept setting from config
    ${auto_accept}=    Get Variable Value    ${POPUP_HANDLING.auto_accept_alerts}    ${True}
    # Handle popup based on setting
    Run Keyword If    ${auto_accept}    Accept Alert
    ...    ELSE    Click Element    ${POPUP_HANDLING.close_button_selector}

Handle Blacklisted Popup
    [Documentation]    Handles blacklisted popups (e.g., ads, spam)
    # Get auto-dismiss setting from config
    ${auto_dismiss}=    Get Variable Value    ${POPUP_HANDLING.auto_dismiss_alerts}    ${True}
    # Handle popup based on setting
    Run Keyword If    ${auto_dismiss}    Dismiss Alert
    ...    ELSE    Click Element    ${POPUP_HANDLING.close_button_selector}

Handle Unknown Popup
    [Documentation]    Handles popups not in whitelist or blacklist
    # Get ignore setting from config
    ${ignore_popups}=    Get Variable Value    ${POPUP_HANDLING.ignore_popups}    ${False}
    Return From Keyword If    ${ignore_popups}
    # Close popup if not ignored
    Click Element    ${POPUP_HANDLING.close_button_selector}
