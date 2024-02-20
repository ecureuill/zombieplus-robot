*** Settings ***
Documentation    Admin Tv Shows Page - test suit for Create Tv Shows feature
Resource            ../../../../resources/pages/AdminTvShowsRegister.resource
Resource            ../../../../resources/pages/AdminLoginPage.resource
Test Setup        Test Setup    ${TVSHOWS_DATA}
Test Teardown    Take Screenshot    fullPage=True

*** Variables ***
${TVSHOWS_DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${tvshows_data}
    DB.Execute Sql    DELETE FROM tvshows

    ${value}    Get Fixture    
    ...    file_name=tvshows    
    ...    scenario=create_feature
    Set Test Variable    ${tvshows_data}    ${value}

    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Start Browser Context     page_url=admin/login
    Autenthicate User         data=${user}
    Verify Is URL Page        page_url=admin/movies
    Go to URL                 page_url=admin/tvshows/register

Add A Tv Show And Verify Its Success
    [Arguments]    ${tvshow}
    Go to URL                 page_url=admin/tvshows/register
    Fill Tv Show Form    tvshow=${tvshow}
    Submit Tv Show Form
    Verify Modal Is Opened
    Verify Modal Success Message    title_message=Ótima notícia!    body_message=A série '${tvshow}[title]' foi adicionada ao catálogo.
    Close Modal

Fail To Add A Tv Show
    [Arguments]    ${tvshow}    ${alert_list}
    Go to URL                 page_url=admin/tvshows/register
    Fill Tv Show Form    tvshow=${tvshow}
    Submit Tv Show Form
    ${alert_list}  Get Json From String    string=${alert_list}

    FOR  ${alert}  IN  @{alert_list}
        Verify Field Has Alert Text    field_selector=${alert}[selector]    alert_text=${alert}[text]
    END

*** Test Cases ***

Should add a tv show
    [Tags]    smoke
    [Template]    Add A Tv Show And Verify Its Success
    ${TVSHOWS_DATA}[success][not_featured]
    ${TVSHOWS_DATA}[success][featured]

Should not add tv show with duplicated title
    ${tvshow}     Set Variable     ${TVSHOWS_DATA}[failure][duplicate]
    Create Tv Show    tvshow_data=${tvshow}
    
    Fill Tv Show Form    tvshow=${tvshow}
    Submit Tv Show Form
    Verify Modal Is Opened
    Verify Modal Success Message    title_message=Atenção!    body_message=O título '${tvshow}[title]' já consta em nosso catálogo. Por favor, verifique se há necessidade de atualizações ou correções para este item.
        
Should not add tv show with invalid or missing data
    [Template]    Fail To Add A Tv Show
    ${TVSHOWS_DATA}[failure][required]    '[{"selector":"title", "text":"Campo obrigatório"}, {"selector":"overview", "text":"Campo obrigatório"}]'
