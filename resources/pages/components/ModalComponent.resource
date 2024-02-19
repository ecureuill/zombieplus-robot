*** Settings ***
Documentation    Modal component actions and elements

Resource    BaseComponent.resource

*** Variables ***
${MODAL_SELECTOR}            dialog
${BUTTON_CLOSE_SELECTOR}     ${MODAL_SELECTOR} button[name=OK]

*** Keywords ***
Verify Modal Is Opened
    ${modal_element}   Get Element By Role    role=DIALOG
    Wait For Elements State    selector=${modal_element}    state=visible    timeout=5s

Verify Modal Success Message
    [Arguments]    ${title_message}    ${body_message}

    ${modal_element}   Get Element By Role    role=DIALOG

    ${modal_text} =    Get Text    selector=${modal_element}
    Should Be Equal    ${modal_text}    ${title_message}\n${body_message}\nOk