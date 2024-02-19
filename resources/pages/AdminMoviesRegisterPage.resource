*** Settings ***
Documentation        Admin Movies Register Page - elements and actions
Resource        ./BasePage.resource
Resource        ./components/FormComponent.resource
Resource        ./components/ModalComponent.resource

*** Variables ***
${HEADING_PAGE_SELECTOR}         //h1[text()="Cadastrar novo Filme"]
${BUTTON_GOBACK_SELECTOR}        //button[text()="Voltar"]
${BUTTON_REGISTER_SELECTOR}      //button[text()="Cadastrar"]
${INPUT_TITLE_SELECTOR}          label[for=title] input
${INPUT_OVERVIEW_SELECTOR}       label[for=overview] textarea
${INPUT_FILE_SELECTOR}           input[type=file]
${SELECT_COMPANY_SELECTOR}       //div[@id="select_company_id"] //input[@type="text"]
${SELECT_YEAR_SELECTOR}          //div[@id="select_year"] // input[@type="text"]
${CHECKBOX_FEATURED_SELECTOR}    //input[@role="switch"]//..

*** Keywords ***
Go Back
    Click    selector=${BUTTON_GOBACK_SELECTOR}


Verify Is Page Opened
    Verify Is URL Page    page_url=admin/movies/register

Fill Movie Form
    [Arguments]    ${movie}
    Fill Text    selector=${INPUT_TITLE_SELECTOR}    txt=${movie}[title]
    Fill Text    selector=${INPUT_OVERVIEW_SELECTOR}    txt=${movie}[overview]

    ${cover_exists}    Evaluate    expression=${movie}.get("cover") is not None
    IF  ${cover_exists}
        Upload File By Selector    selector=${INPUT_FILE_SELECTOR}    path=${EXECDIR}${FIXTURE_PATH}${movie}[cover]
    END
    
    ${featured_is_true}    Evaluate    expression=${movie}[featured] == True
    IF  ${featured_is_true}
        Check Checkbox    selector=${CHECKBOX_FEATURED_SELECTOR}    
    END

    Fill Text    selector=${SELECT_COMPANY_SELECTOR}    txt=${movie}[company]
    Keyboard Key    action=press    key=Enter

    Fill Text    selector=${SELECT_YEAR_SELECTOR}    txt=${movie}[release_year]
    Keyboard Key    action=press    key=Enter

Submit Movie Form
    Click    selector=${BUTTON_REGISTER_SELECTOR}