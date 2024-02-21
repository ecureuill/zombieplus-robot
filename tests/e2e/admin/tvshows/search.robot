*** Settings ***
Documentation    Admin Tv Shows Page - test suit for Search feature
Resource                ../../../../resources/pages/BasePage.resource
Resource                ../../../../resources/pages/AdminTvShowsPage.resource
Resource                ../../../../resources/pages/AdminLoginPage.resource
Suite Setup             Suite Setup    tvshows_data=${TVSHOWS_DATA}
Test Setup              Test Setup
Test Teardown           Take Screenshot    fullPage=True

*** Variables ***
${TVSHOWS_DATA}

*** Keywords ***
Suite Setup
    [Arguments]    ${tvshows_data}

    DB.Execute Sql    sql=DELETE FROM tvshows

    ${value}    Get Fixture    
    ...    file_name=tvshows    
    ...    scenario=search_feature
    Set Suite Variable    ${tvshows_data}    ${value}

    FOR  ${tvshows}  IN  @{tvshows_data}[data]
        Create Tvshow    tvshow_data=${tvshows}
    END

Test Setup
    ${value}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success

    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${value}
    #wait for login process
    Verify Is URL Page    page_url=admin/movies
    Go to URL    page_url=admin/tvshows

Search
    [Arguments]    ${search_input}    ${expected_output}=${None}
    Search Content    content=${search_input}
    ${is_list}    Evaluate    isinstance(${expected_output}, list)
    
    IF    ${is_list}
        ${length}    Get Length    ${expected_output}
        IF    ${length} > 0
            Verify Tv Shows Result Is Not Empty    titles=${expected_output}
        ELSE  
            Verify Tv Shows Result Is Empty
        END
    END

    

*** Test Cases ***
Should enable clear button
    Search   
    ...    search_input=${TVSHOWS_DATA}[filter][input]
    Verify Serchbar Clear Button Is Visible

Should clear search
    Search    
    ...    search_input=${TVSHOWS_DATA}[clear_filter][input]
    Clear Search
    Verify All Tv Shows Are Listed    tvshows=${TVSHOWS_DATA}[data]

Should search by a tvshows title
    [Tags]    smoke
    Search    
    ...    search_input=${TVSHOWS_DATA}[filter][input]    
    ...    expected_output=${TVSHOWS_DATA}[filter][outputs]


Should not retrive tvshows
    Search    
    ...    search_input=${TVSHOWS_DATA}[no_records][input]
    ...    expected_output=${TVSHOWS_DATA}[no_records][outputs]
    Verify TvShows Result Is Empty    

