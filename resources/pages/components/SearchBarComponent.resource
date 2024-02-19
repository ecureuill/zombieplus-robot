*** Settings ***
Documentation           Search Bar Component - elements and actions
Resource                ./FormComponent.resource

*** Variables ***
${INPUT_SEARCH_SELECTOR}        input[placeholder^=Busque]
${SVG_CLEAR_BUTTON_SELECTOR}    ${INPUT_SEARCH_SELECTOR} + svg
*** Keywords ***
Search Content
    [Arguments]       ${content}
    Fill Form Input    input_locator=${INPUT_SEARCH_SELECTOR}    text=${content}
    Submit Form

Clear Search
    Click    selector=${SVG_CLEAR_BUTTON_SELECTOR}


Verify SerchBar Clear Button Is Visible
    Wait For Elements State    
    ...    selector=${SVG_CLEAR_BUTTON_SELECTOR}
    ...    state=visible    
    ...    timeout=5s
