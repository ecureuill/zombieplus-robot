*** Settings ***
Documentation        Table Componenet - elements and actions
Resource        BaseComponent.resource

*** Variables ***
${TABLE_SELECTOR}        table

*** Keywords ***
Verify Table Contains
    [Arguments]    ${cell_class_selector}    ${text}

    Wait For Elements State    
    ...    selector=//td[@class="title" and text() = "${text}"]
    ...    state=visible    
    ...    timeout=5s
  
Verify Table Rows Count
    [Arguments]    ${count}
    ${rows}   Get Element Count    
    ...    selector=tr    
    ...    assertion_operator=equal    
    ...    assertion_expected=${count}

Verify Table Is Visible
    Wait For Elements State    
    ...    selector=${TABLE_SELECTOR}    
    ...    state=visible    
    ...    timeout=5s

Verify Table Is Not Visible
    Wait For Elements State    
    ...    selector=${TABLE_SELECTOR}    
    ...    state=hidden
    ...    timeout=5s