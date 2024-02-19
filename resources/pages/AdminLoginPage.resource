*** Settings ***
Documentation       Admin Login Page - elements and actions
Resource            ./BasePage.resource
Resource            ./components/FormComponent.resource

*** Variables ***
${INPUT_EMAIL_SELECTOR}        input[placeholder=E-mail]
${INPUT_PASSWORD_SELECTOR}     input[placeholder=Senha]
${INPUT_SUBMIT_SELECTOR}       button[type=submit]

*** Keywords ***
Fill Admin Login Form
    [Arguments]    ${data}
    Fill Form Input    input_locator=${INPUT_EMAIL_SELECTOR}    text=${data}[email]
    Fill Form Input    input_locator=${INPUT_PASSWORD_SELECTOR}    text=${data}[password]

Submit Admin Login Form
    Click    selector=${INPUT_SUBMIT_SELECTOR}

Autenthicate User
    [Arguments]    ${data}
    Fill Admin Login Form    data=${data}
    Submit Admin Login Form

Verify Admin Login Form Has Alert Text
    [Arguments]    ${password_alert_text}    ${email_alert_text}
    
    ${password_alert_length}    Get Length    item=${password_alert_text}
    ${email_alert_length}       Get Length    item=${email_alert_text}

    IF  ${password_alert_length > 0}
        ${password_alert_element}     Get Element    selector=div:has(${INPUT_PASSWORD_SELECTOR}) > span.alert

        Wait For Elements State
        ...    selector=${password_alert_element}    
        ...    state=visible    
        ...    timeout=5s
    
        ${password_alert}    Get Text    selector=${password_alert_element}

        Should Be Equal    ${password_alert}    ${password_alert_text}
        
    END
    
    IF  ${email_alert_length > 0}
        ${email_alert_element}    Get Element    selector=div:has(${INPUT_PASSWORD_SELECTOR}) > span.alert
        
        Wait For Elements State    
        ...    selector=${email_alert_element}    
        ...    state=visible    
        ...    timeout=5s

        ${email_alert}   Get Text    selector=${email_alert_element}

        Should Be Equal    ${email_alert}    ${email_alert_text}
    END
    
