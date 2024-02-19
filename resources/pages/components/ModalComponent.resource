*** Settings ***
Documentation    Modal Component - actions and elements

Resource    BaseComponent.resource

*** Variables ***
${MODAL_SELECTOR}            //div[@role="dialog"]
${BUTTON_CLOSE_SELECTOR}     ${MODAL_SELECTOR}//button[text()="Ok"]

*** Keywords ***
Close Modal
    Click    selector=${BUTTON_CLOSE_SELECTOR}
Verify Modal Is Opened
    ${modal_element}   Get Element By Role    role=DIALOG
    Wait For Elements State    selector=${modal_element}    state=visible    timeout=5s

Verify Modal Success Message
    [Arguments]    ${title_message}    ${body_message}
    
    ${modal_element}   Get Element By Role    role=DIALOG
    Wait For Elements State    selector=${MODAL_SELECTOR}//h2[text()="${title_message}"]
    Wait For Elements State    selector=${MODAL_SELECTOR}//div[text()="${body_message}"]