*** Settings ***
Documentation        Admin Tv Shows Register Page - elements and actions
Resource        ./BasePage.resource
Resource        ./components/FormComponent.resource
Resource        ./components/ModalComponent.resource

*** Variables ***
${HEADING_PAGE_SELECTOR}         //h1[text()="Cadastrar nova Série"]
${BUTTON_GOBACK_SELECTOR}        //button[text()="Voltar"]
${BUTTON_REGISTER_SELECTOR}      //button[text()="Cadastrar"]
${INPUT_TITLE_SELECTOR}          label[for=title] input
${INPUT_OVERVIEW_SELECTOR}       label[for=overview] textarea
${INPUT_FILE_SELECTOR}           input[type=file]
${INPUT_SEASONS_SELECTOR}          label[for=seasons] input
${SELECT_COMPANY_SELECTOR}       //div[@id="select_company_id"] //input[@type="text"]
${SELECT_YEAR_SELECTOR}          //div[@id="select_year"] // input[@type="text"]
${CHECKBOX_FEATURED_SELECTOR}    //input[@role="switch"]//..

*** Keywords ***
Go Back
    Click    selector=${BUTTON_GOBACK_SELECTOR}

Fill Tv Show Form
    [Arguments]    ${tvshow}
    Log    ${ tvshow}
    Fill Text    selector=${INPUT_TITLE_SELECTOR}    txt=${tvshow}[title]
    Fill Text    selector=${INPUT_OVERVIEW_SELECTOR}    txt=${tvshow}[overview]

    ${cover_exists}    Evaluate    expression=${tvshow}.get("cover") is not None
    IF  ${cover_exists}
        Upload File By Selector    selector=${INPUT_FILE_SELECTOR}    path=${EXECDIR}${FIXTURE_PATH}${tvshow}[cover]
    END
    
    ${featured_is_true}    Evaluate    expression=${tvshow}[featured] == True
    IF  ${featured_is_true}
        Check Checkbox    selector=${CHECKBOX_FEATURED_SELECTOR}    
    END

    Fill Text    selector=${SELECT_COMPANY_SELECTOR}    txt=${tvshow}[company]
    Keyboard Key    action=press    key=Enter

    Fill Text    selector=${SELECT_YEAR_SELECTOR}    txt=${tvshow}[release_year]
    Keyboard Key    action=press    key=Enter

    Fill Text    selector=${INPUT_SEASONS_SELECTOR}    txt=${tvshow}[seasons]

Submit Tv Show Form
    Click    selector=${BUTTON_REGISTER_SELECTOR}