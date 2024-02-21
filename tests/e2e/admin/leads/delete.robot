*** Settings *** 
Documentation        Admin Leads Page - test suit for Delete Lead feature
Resource            ../../../../resources/pages/AdminLeadsPage.resource
Resource            ../../../../resources/pages/AdminLoginPage.resource
Test Setup        Test Setup    ${LEADS_DATA}
Test Teardown    Take Screenshot    fullPage=True

*** Variables ***
${LEADS_DATA}

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
    [Arguments]    ${email}    ${data}
    
    ${data_is_array}    Evaluate    expression=isinstance(${data}, list)

    IF  ${data_is_array}
        FOR  ${lead}  IN  @{data}
            Create Lead    payload=${lead}
        END
    ELSE
        Create Lead    payload=${data}
    END
    
    Reload
    Delete Request    email=${email}
    Confirm Deletion
    Verify Modal Is Opened
    Verify Modal Success Message
    ...    title_message=Tudo certo!
    ...    body_message=Lead removido com sucesso.

*** Test Cases ***
Should remove a lead
    Delete    email=${LEADS_DATA}[remove]    data=${LEADS_DATA}[data]