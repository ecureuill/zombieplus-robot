*** Settings *** 
Documentation        Admin Tv Shows Page - test suit for Delete Tv Show feature
Resource            ../../../../resources/pages/AdminTvShowsPage.resource
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
    ...    scenario=delete_feature
    Set Test Variable    ${tvshows_data}    ${value}

    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${user}
    Verify Is URL Page    page_url=admin/movies
    Go to URL    page_url=admin/tvshows

Delete
    [Arguments]    ${title}    ${data}
    
    ${data_is_array}    Evaluate    expression=isinstance(${data}, list)

    IF  ${data_is_array}
        FOR  ${tvshows}  IN  @{data}
            Create Tv Show    tvshow_data=${tvshows}
        END
    ELSE
        Create Tv Show    tvshow_data=${data}
    END
    
    Reload
    Log    ${title}
    Delete Request    title=${title}
    Confirm Deletion
    Verify Modal Is Opened
    Verify Modal Success Message
    ...    title_message=Tudo certo!
    ...    body_message=Série removida com sucesso.

*** Test Cases ***
Should remove a tv show
    Delete    title=${TVSHOWS_DATA}[remove]    data=${TVSHOWS_DATA}[data]