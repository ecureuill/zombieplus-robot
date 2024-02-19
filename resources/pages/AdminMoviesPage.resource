*** Settings ***
Documentation            Admin Movies Page - elements and actions
Resource                 ./components/HeaderComponent.resource
Resource                 ./components/SearchBarComponent.resource
Resource                 ./components/TableComponent.resource
Resource                 ./components/ModalComponent.resource
Resource                 ./BasePage.resource

*** Variables ***

*** Keywords ***
Click Add Movie Link
    Click    selector=a[href="/admin/movies/register"]

Delete Request
    [Arguments]     ${title}
    Click    selector=//tr[td[@class="title" and text()="${title}"]]/td[@class="remove-item"]/button

    # ${button_element}=    Evaluate JavaScript    td.title
    # ...    (elements, arg) => {
    # ...        for (e of elements) {
    # ...            if(e.textContent.trim() === arg){
    # ...                e.closest('tr').querySelector('td.remove-item button').click();
    # ...                return;
    # ...            }
    # ...        }
    # ...    }
    # ...    all_elements=True
    # ...    arg=${title}

Confirm Deletion
    Click    selector=.confirm-removal
Verify Movie Result Is Empty
    Verify Table Is Not Visible
    ${text_element}    Get Element By    
    ...    selection_strategy=Text    
    ...    text=Nenhum registro encontrado!    
    ...    exact=True
    Wait For Elements State
    ...    selector=${text_element}
    ...    state=visible
    ...    timeout=5s

Verify Movie Result Is Not Empty
    [Arguments]    ${titles}
    Verify Table Is Visible
    Verify All Titles Are Listed    titles=${titles}

Verify All Movies Are Listed
    [Arguments]    ${movies}
    
    ${movies_lenght}    Get Length    item=${movies}
    Verify Table Rows Count    count=${movies_lenght}
    
    FOR  ${movie}  IN  @{movies}
        Log    ${movie}
        Verify Table Contains    
        ...    cell_class_selector=td.title    
        ...    text=${movie}[title]    
    END

Verify All Titles Are Listed
    [Arguments]    ${titles}

    ${movies_lenght}    Get Length    item=${titles}
    Verify Table Rows Count    count=${movies_lenght}
    
    FOR  ${movie}  IN  @{titles}
        Verify Table Contains    
        ...    cell_class_selector=td.title    
        ...    text=${movie}   
    END