*** Settings *** 
Documentation        Admin Leads Page - test suit for Delete Lead feature
Resource            ../../../../resources/pages/AdminLeadsPage.resource
Resource            ../../../../resources/pages/AdminLoginPage.resource
Test Setup        Test Setup    ${MOVIES_DATA}
Test Teardown    Take Screenshot    fullPage=True

*** Variables ***
${MOVIES_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${leads_data}
    DB.Execute Sql    DELETE FROM leads

    ${value}    Get Fixture    
    ...    file_name=leads    
    ...    scenario=delete_feature
    Set Test Variable    ${leads_data}    ${value}

    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${user}
    Verify Is URL Page    page_url=admin/movies
    Go to URL    page_url=admin/leads    

Delete
    [Arguments]    ${title}    ${data}
    
    ${data_is_array}    Evaluate    expression=isinstance(${data}, list)

    IF  ${data_is_array}
        FOR  ${movie}  IN  @{data}
            Create Lead    payload=${movie}
        END
    ELSE
        Create Lead    payload=${data}
    END
    
    Reload
    Delete Request    email=${title}
    Confirm Deletion
    Verify Modal Is Opened
    Verify Modal Success Message
    ...    title_message=Tudo certo!
    ...    body_message=Lead removido com sucesso.

*** Test Cases ***
Should remove a movie
    Delete    title=${MOVIES_DATA}[remove]    data=${MOVIES_DATA}[data]

Should remove a movie with special character
    [Tags]    special characters
    [Template]    Delete

    FOR  ${movie}  IN  @{MOVIES_DATA}[special_character]
        ${movie}[title]    ${movie}
    END