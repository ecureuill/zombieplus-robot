*** Settings ***
Documentation           Form Component - elements and actions
Resource                ./BaseComponent.resource

*** Variables ***
${FORM}                form
${BUTTON_SUBMIT}       ${FORM} *[type=submit]

*** Keywords ***
Fill Form Input
    [Arguments]        ${input_locator}    ${text}
    Fill Text    selector=${FORM} ${input_locator}    txt=${text}

Submit Form
    Click    selector=${BUTTON_SUBMIT}

Verify Field Has Alert Text
    [Arguments]    ${field_selector}    ${alert_text}
    
    ${ALERT_SELECTOR}    Set Variable    label[for=${field_selector}] > span.alert

    ${field_element}    Wait For Elements State    
    ...    selector=${ALERT_SELECTOR}    
    ...    state=visible    
    ...    timeout=5s

    ${field_alert_text}   Get Text    selector=${ALERT_SELECTOR}

    Should Be Equal    ${field_alert_text}    ${alert_text}    
