*** Settings *** 
Documentation        Admin Movies Page - test suit for Delete Movie feature
Resource            ../../../../resources/pages/AdminMoviesPage.resource
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
    ...    scenario=delete_feature
    Set Test Variable    ${movies_data}    ${value}

    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${user}

Delete
    [Arguments]    ${title}    ${data}
    
    ${data_is_array}    Evaluate    expression=isinstance(${data}, list)

    IF  ${data_is_array}
        FOR  ${movie}  IN  @{data}
            Create Movie    movie_data=${movie}
        END
    ELSE
        Create Movie    movie_data=${data}
    END
    
    Reload
    Log    ${title}
    Delete Request    title=${title}
    Confirm Deletion
    Verify Modal Is Opened
    Verify Modal Success Message
    ...    title_message=Tudo certo!
    ...    body_message=Filme removido com sucesso.

*** Test Cases ***
Should remove a movie
    Delete    title=${MOVIES_DATA}[remove]    data=${MOVIES_DATA}[data]

Should remove a movie with special character
    [Tags]    special characters
    [Template]    Delete

    FOR  ${movie}  IN  @{MOVIES_DATA}[special_character]
        ${movie}[title]    ${movie}
    END