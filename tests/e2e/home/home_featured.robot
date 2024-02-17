*** Settings ***
Documentation     Home page test suit
Resource          ../../../resources/pages/HomePage.resource
Library           ../../../resources/libs/Database.py    AS    DB

Test Setup        Test Setup    ${MOVIES_DATA}    ${TVSHOWS_DATA}
Test Teardown     Take Screen Shot    fullPage=True

*** Variables ***
${MOVIES_DATA}
${TVSHOWS_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${movies_data}    ${tvshows_data}
    DB.Execute Sql    DELETE FROM movies
    DB.Execute Sql    DELETE FROM tvshows
    
    ${value}    Get Fixture    file_name=movies    scenario=featured_feature
    Set Test Variable    ${movies_data}    ${value}    
    ${value}    Get Fixture    file_name=tvshows    scenario=featured_feature
    Set Test Variable    ${tvshows_data}    ${value}    

    Start Browser Context

*** Test Cases ***
Should have featuRed movies and tv shows
    Verify Featured Content    
    ...    movies_data=${MOVIES_DATA}    
    ...    tvshows_data=${TVSHOWS_DATA}

Should not have featuRed movies and tv shows
    ${EMPTY_LIST}    Create List
    
    Verify Featured Content    
    ...    movies_data=${EMPTY_LIST}      
    ...    tvshows_data=${EMPTY_LIST}
