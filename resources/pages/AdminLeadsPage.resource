*** Settings ***
Documentation            Admin Leads Page - elements and actions
Resource                 ./components/HeaderComponent.resource
Resource                 ./components/SearchBarComponent.resource
Resource                 ./components/TableComponent.resource
Resource                 ./components/ModalComponent.resource
Resource                 ./BasePage.resource

*** Variables ***

*** Keywords ***
Delete Request
    [Arguments]     ${email}
    Click    selector=//tr[td[text()="${email}"]]/td[@class="remove-item"]/button
    
Confirm Deletion
    Click    selector=.confirm-removal

Verify Lead Result Is Empty
    Verify Table Is Not Visible
    ${text_element}    Get Element By    
    ...    selection_strategy=Text    
    ...    text=Nenhum lead encontrado!
    Wait For Elements State
    ...    selector=${text_element}
    ...    state=visible
    ...    timeout=5s

Verify Lead Result Is Not Empty
    [Arguments]    ${titles}
    Verify Table Is Visible
    Verify All Leads Are Listed    names=${titles}

Verify All Leads Are Listed
    [Arguments]    ${names}

    ${leads_lenght}    Get Length    item=${names}
    Verify Table Rows Count    count=${leads_lenght}
    
    FOR  ${name}  IN  @{names}
        Verify Table Contains    
        ...    cell_class_selector=name
        ...    text=${name}   
    END