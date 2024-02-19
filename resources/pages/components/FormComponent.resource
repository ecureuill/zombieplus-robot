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
