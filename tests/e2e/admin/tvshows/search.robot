*** Settings ***
Documentation    Admin Tv Shows Page - test suit for Search feature
Resource                ../../../../resources/pages/BasePage.resource
Resource                ../../../../resources/pages/AdminTvShowsPage.resource
Resource                ../../../../resources/pages/AdminLoginPage.resource
Test Setup              Test Setup    ${TVSHOWS_DATA}
Test Teardown           Take Screenshot    fullPage=True

*** Variables ***
${TVSHOWS_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${tvshows_data}
    
    DB.Execute Sql    sql=DELETE FROM tvshows

    ${value}    Get Fixture    
    ...    file_name=tvshows    
    ...    scenario=search_feature
    Set Test Variable    ${tvshows_data}    ${value}

    FOR  ${tvshows}  IN  @{tvshows_data}[data]
        Create Tvshow    tvshow_data=${tvshows}
    END

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
    IF  ${expected_output} == ${None}
        Log    DO NOTHING ABOUT OUTPUT
    ELSE IF    ${expected_output} == []
        Verify TV Shows Result Is Empty
    ELSE
        Verify TV Shows Result Is Not Empty    titles=${expected_output}
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
    ...    expected_output=[]
    Verify TvShows Result Is Empty    

