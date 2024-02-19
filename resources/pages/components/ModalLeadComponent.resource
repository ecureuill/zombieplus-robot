*** Settings ***
Documentation    Modal Lead Component - actions and elements

Resource    BaseComponent.resource

*** Variables ***
#seletores
${MODAL}            [data-testid=modal]
${FORM}             ${MODAL} form 
${INPUT_NAME}       ${FORM} input[name=name]
${INPUT_EMAIL}      ${FORM} input[name=email]
${BUTTON_SUBMIT}    ${FORM} button
${BUTTON_CLOSE}     ${MODAL} button[data-testid=close-button]

*** Keywords ***
Fill Lead Form
    [Arguments]    ${data}
    Fill Text    selector=${INPUT_NAME}    txt=${data}[name]
    Fill Text    selector=${INPUT_EMAIL}    txt=${data}[email]

Submit Lead Form
    Click    selector=${BUTTON_SUBMIT}

Close Lead Modal
    Click    selector=${BUTTON_CLOSE}

Verify Lead Modal Is Open
    Wait For Elements State    selector=${MODAL}    state=visible

Verify Lead Modal Is Closed
    Wait For Elements State    selector=${MODAL}    state=hidden

Verify Lead Form Alert Count
    [Arguments]    ${alert_count}
    Get Element Count    selector=${form} .alert    assertion_operator=equal    assertion_expected=${alert_count}


Verify Lead Form Has Alert Text
    [Arguments]    ${name_alert_text}    ${email_alert_text}
    
    ${name_alert_length}    Get Length    item=${name_alert_text}
    ${email_alert_length}   Get Length    item=${email_alert_text}

    IF  ${name_alert_length > 0}
        ${name_alert_element}     Get Element    selector=label[for=name] span.alert

        Wait For Elements State
        ...    selector=${name_alert_element}    
        ...    state=visible    
        ...    timeout=5s
    
        ${name_alert}    Get Text    selector=${name_alert_element}

        Should Be Equal    ${name_alert}    ${name_alert_text}
        
    END
    
    IF  ${email_alert_length > 0}
        ${email_alert_element}    Get Element    selector=label[for=email] span.alert
        
        Wait For Elements State    
        ...    selector=${email_alert_element}    
        ...    state=visible    
        ...    timeout=5s

        ${email_alert}   Get Text    selector=${email_alert_element}

        Should Be Equal    ${email_alert}    ${email_alert_text}
    END
    



# VERIFY INPUT EMAIL ALERT TEXT
#     [Arguments]    ${alert_text}



