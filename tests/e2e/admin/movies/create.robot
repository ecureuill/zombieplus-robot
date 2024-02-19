*** Settings ***
Documentation    Admin Movies Page - test suit for Create Movie feature
Resource            ../../../../resources/pages/AdminMoviesRegisterPage.resource
Resource            ../../../../resources/pages/AdminLoginPage.resource
Test Setup        Test Setup    ${MOVIES_DATA}
Test Teardown    Take Screenshot    fullPage=True

*** Variables ***
${MOVIES_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${movies_data}
    DB.Execute Sql    DELETE FROM movies

    ${value}    Get Fixture    
    ...    file_name=movies    
    ...    scenario=create_feature
    Set Test Variable    ${movies_data}    ${value}

    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Start Browser Context     page_url=admin/login
    Autenthicate User         data=${user}
    Verify Is URL Page        page_url=admin/movies
    Go to URL                 page_url=admin/movies/register

Add A Movie
    [Arguments]    ${movie}
    Go to URL                 page_url=admin/movies/register
    Fill Movie Form    movie=${movie}
    Submit Movie Form
    Verify Modal Is Opened
    Verify Modal Success Message    title_message=Ótima notícia!    body_message=O filme '${movie}[title]' foi adicionado ao catálogo.
    Close Modal

Fail To Add A Movie
    [Arguments]    ${movie}
    Go to URL                 page_url=admin/movies/register
    Fill Movie Form    movie=${movie}
    Submit Movie Form


*** Test Cases ***
Should add a movie
    [Tags]    smoke
    [Template]    Add A Movie
    ${MOVIES_DATA}[success][not_featured]
    ${MOVIES_DATA}[success][featured]

Should add a movie with special characters
    [Tags]    special characters
    [Template]    Add A Movie
    FOR  ${movie}  IN  @{MOVIES_DATA}[success][special_character]
        ${movie}
    END

Should not add movie with duplicated title
    ${movie}     Set Variable     ${MOVIES_DATA}[failure][duplicate]
    Create Movie    movie_data=${movie}
    
    Fill Movie Form    movie=${movie}
    Submit Movie Form
    Verify Modal Is Opened
    Verify Modal Success Message    title_message=Atenção!    body_message=O título '${movie}[title]' já consta em nosso catálogo. Por favor, verifique se há necessidade de atualizações ou correções para este item.
    
Should not add movie with invalid or missing data
    [Template]    Fail To Add A Movie
    ${MOVIES_DATA}[failure][required]
    ${MOVIES_DATA}[failure][long_title]
    ${MOVIES_DATA}[failure][invalid_cover]