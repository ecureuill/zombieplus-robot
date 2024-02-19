*** Settings ***
Documentation    Home Page - actions and elements
Resource    BasePage.resource
Resource    ./components/ModalLeadComponent.resource

*** Variables ***
${BUTTON_LEAD}      APERTE O PLAY... SE TIVER CORAGEM

*** Keywords ***
Open Lead Modal
    ${button}     Get Element By Role    BUTTON    name=${BUTTON_LEAD}
    Click    selector=${button}

Go To Admin
    ${link}    Get Element By Role    role=LINK    name=Admin
    Click    selector=${link}
    Verify Is URL Page    page_url=admin/login

Verify Featured Content
    [Arguments]    ${movies_data}    ${tvshows_data}
    ${movies_count}    Get Length    item=${movies_data}
    ${tvshows_count}    Get Length    item=${tvshows_data}
    Log    ${movies_count}
    FOR  ${movie}  IN  @{movies_data}
      Create Movie    ${movie}
    END
    
    FOR  ${tvshow}  IN  @{tvshows_data}
      Create Tvshow    ${tvshow}
    END
    
    Reload
    
    ${parent_section}=    Get Element    xpath=//h2[contains(text(), 'Destaques')]/ancestor::section
    @{images}=    Get Elements    ${parent_section} >> img
    

    ${images_count}    Get Length    item=${images}

    ${content_count}    Evaluate    expression=${movies_count}+${tvshows_count}    
    Should Be Equal As Integers    first=${content_count}    second=${images_count}
