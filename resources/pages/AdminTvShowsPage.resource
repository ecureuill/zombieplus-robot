*** Settings ***    
Documentation        Admin Tv Shows Page - elements and actions

Resource    ./BasePage.resource
Resource    ./components/TableComponent.resource
Resource    ./components/SearchBarComponent.resource
Resource    ./components/ModalComponent.resource

*** Keywords ***
Click Add TV Shows Link
    Click    selector=a[href="/admin/tvshows/register"]

Delete Request
    [Arguments]     ${title}
    Click    selector=//tr[td[@class="title" and text()="${title}"]]/td[@class="remove-item"]/button

Confirm Deletion
    Click    selector=.confirm-removal

Verify TV Shows Result Is Empty
    Verify Table Is Not Visible
    ${text_element}    Get Element By    
    ...    selection_strategy=Text    
    ...    text=Nenhum registro encontrado!    
    ...    exact=True
    Wait For Elements State
    ...    selector=${text_element}
    ...    state=visible
    ...    timeout=5s

Verify TV Shows Result Is Not Empty
    [Arguments]    ${titles}
    Verify Table Is Visible
    Verify All Titles Are Listed    titles=${titles}

Verify All TV Shows Are Listed
    [Arguments]    ${tvshows}
    
    ${tvshows_lenght}    Get Length    item=${tvshows}
    Verify Table Rows Count    count=${tvshows_lenght}
    
    FOR  ${movie}  IN  @{tvshows}
        Log    ${movie}
        Verify Table Contains    
        ...    cell_class_selector=title    
        ...    text=${movie}[title]    
    END

Verify All Titles Are Listed
    [Arguments]    ${titles}

    ${tvshows_lenght}    Get Length    item=${titles}
    Verify Table Rows Count    count=${tvshows_lenght}
    
    FOR  ${movie}  IN  @{titles}
        Verify Table Contains    
        ...    cell_class_selector=title    
        ...    text=${movie}   
    END