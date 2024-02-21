*** Settings ***
Documentation            Admin Movies Page - test suit for Search Movie feature
Resource                ../../../../resources/pages/BasePage.resource
Resource                ../../../../resources/pages/AdminMoviesPage.resource
Resource                ../../../../resources/pages/AdminLoginPage.resource
Suite Setup              Suite Setup    ${MOVIES_DATA}
Test Setup              Test Setup
Test Teardown           Take Screenshot    fullPage=True

*** Variables ***
${MOVIES_DATA}

*** Keywords ***
Suite Setup
    [Arguments]    ${movies_data}
    DB.Execute Sql    sql=DELETE FROM movies

    ${value}    Get Fixture    
    ...    file_name=movies    
    ...    scenario=search_feature
    Set Suite Variable    ${movies_data}    ${value}

    FOR  ${movie}  IN  @{movies_data}[data]
        Create Movie    movie_data=${movie}
    END

Test Setup
        ${value}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success

    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${value}

Search
    [Arguments]    ${search_input}    ${expected_output}=${None}

    Search Content    content=${search_input}
    
    ${is_list}    Evaluate    isinstance(${expected_output}, list)
    
    IF    ${is_list}
        ${length}    Get Length    ${expected_output}
        IF    ${length} > 0
            Verify Movie Result Is Not Empty    titles=${expected_output}
        ELSE  
            Verify Movie Result Is Empty
        END
    END
    
Search With Special Characters
    [Arguments]    ${search_input}
    DB.Execute Sql    sql=DELETE FROM movies
    
    FOR  ${movie}  IN  @{MOVIES_DATA}[special_character]
        Create Movie    movie_data=${movie}
    END
    
    ${expected_output}    Create List    ${search_input}

    Search    
    ...    search_input=${search_input}    
    ...    expected_output=${expected_output}

*** Test Cases ***
Should enable clear button
    Search   
    ...     search_input=${MOVIES_DATA}[filter][input]
    Verify Serchbar Clear Button Is Visible

Should clear search
    Search    
    ...    search_input=${MOVIES_DATA}[filter][input]
    Clear Search
    Verify All Movies Are Listed    movies=${MOVIES_DATA}[data]

Should search by a movie title
    [Tags]    smoke
    Search    
    ...    search_input=${MOVIES_DATA}[filter][input]    
    ...    expected_output=${MOVIES_DATA}[filter][outputs]


Should search by a movie title with special character
    [Tags]    special characters
    [Template]    Search With Special Characters 
    FOR  ${movie}  IN  @{MOVIES_DATA}[special_character]
        ${movie}[title]
    END

Should not retrive movie
    Search    
    ...    search_input=${MOVIES_DATA}[no_records][input]
    ...    expected_output=${MOVIES_DATA}[no_records][outputs]
    Verify Movie Result Is Empty    

