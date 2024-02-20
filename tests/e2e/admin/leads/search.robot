*** Settings ***
Documentation            Admin Leads Page - test suit for Search Lead feature
Resource                ../../../../resources/pages/BasePage.resource
Resource                ../../../../resources/pages/AdminLeadsPage.resource
Resource                ../../../../resources/pages/AdminLoginPage.resource
Test Setup              Test Setup    ${LEADS_DATA}
Test Teardown           Take Screenshot    fullPage=True

*** Variables ***
${LEADS_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${leads_data}
    
    DB.Execute Sql    sql=DELETE FROM leads

    ${value}    Get Fixture    
    ...    file_name=leads    
    ...    scenario=search_feature
    Set Test Variable    ${leads_data}    ${value}

    FOR  ${movie}  IN  @{leads_data}[data]
        Create Lead    payload=${movie}
    END

    ${value}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success

    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${value}
    Verify Is URL Page    page_url=admin/movies
    Go to URL    page_url=admin/leads

Search
    [Arguments]    ${search_input}    ${expected_output}=${None}
    Search Content    content=${search_input}
    IF  ${expected_output} == ${None}
        Log    DO NOTHING ABOUT OUTPUT
    ELSE IF    ${expected_output} == []
        Verify Lead Result Is Empty
    ELSE
        Verify Lead Result Is Not Empty    titles=${expected_output}
    END
    

*** Test Cases ***
Should enable clear button
    Search   
    ...     search_input=${LEADS_DATA}[filter][input]
    Verify Serchbar Clear Button Is Visible

Should clear search
    Search    
    ...    search_input=${LEADS_DATA}[clear_filter][input]
    Clear Search
    Verify All Leads Are Listed    names=${LEADS_DATA}[clear_filter][outputs]

Should search by a lead email
    [Tags]    smoke
    Search    
    ...    search_input=${LEADS_DATA}[filter][input]    
    ...    expected_output=${LEADS_DATA}[filter][outputs]


Should not retrive a lead
    Search    
    ...    search_input=${LEADS_DATA}[no_records][input]
    ...    expected_output=[]
    Verify Lead Result Is Empty

