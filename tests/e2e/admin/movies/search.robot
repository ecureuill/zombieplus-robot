*** Settings ***
Documentation            Admin Movies Page - test suit for Search Movie feature
Resource                ../../../../resources/pages/BasePage.resource
Resource                ../../../../resources/pages/AdminMoviesPage.resource
Resource                ../../../../resources/pages/AdminLoginPage.resource
Test Setup              Test Setup    ${MOVIES_DATA}
Test Teardown           Take Screenshot    fullPage=True

*** Variables ***
${MOVIES_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${movies_data}
    
    DB.Execute Sql    sql=DELETE FROM movies

    ${value}    Get Fixture    
    ...    file_name=movies    
    ...    scenario=search_feature
    Set Test Variable    ${movies_data}    ${value}

    FOR  ${movie}  IN  @{movies_data}[data]
        Create Movie    movie_data=${movie}
    END

    ${value}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success

    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${value}

Search
    [Arguments]    ${search_input}    ${expected_output}
    Search Content    content=${search_input}

*** Test Cases ***
Should enable clear button
    Search   
    ...     content=${MOVIES_DATA}[filter][input]
    ...    expected_output=[]
    Verify Serchbar Clear Button Is Visible

Should clear search
    Search    
    ...    content=${MOVIES_DATA}[filter][input]
    ...    expected_output=[]
    Clear Search
    Verify All Movies Are Listed    movies=${MOVIES_DATA}[data]

Should search by a movie title
    [Tags]    smoke
    Search    
    ...    search_input=${MOVIES_DATA}[filter][input]    
    ...    expected_output=${MOVIES_DATA}[filter][outputs]


Should search by a movie title with special character
    [Tags]    special characters
    [Template]    Search  
    FOR  ${movie}  IN  ${MOVIES_DATA}[special_character]
        ${MOVIES_DATA}[filter][input]    ${MOVIES_DATA}[filter][outputs]
    END

Should not retrive movie
    Search    
    ...    content=${MOVIES_DATA}[no_records][input]
    ...    expected_output=[]
    Verify Movie Result Is Empty    

