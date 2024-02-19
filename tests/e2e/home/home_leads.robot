*** Settings ***
Documentation     Home Page - test suit for Leads registration feature
Resource          ../../../resources/pages/HomePage.resource
Resource          ../../../resources/pages/components/ModalComponent.resource

Test Setup        Test Setup    ${DATA}
Test Teardown     Take Screen Shot

*** Variables ***
${DATA}

*** Keywords ***
Test Setup
    [Arguments]    ${data}
    DB.Execute Sql    DELETE FROM leads
    ${value}    Get Fixture    file_name=leads    scenario=create_feature
    Set Test Variable    ${data}    ${value}    
    Log    ${DATA}
    Start Browser Context

Open Lead Modal And Submit Form    
    [Arguments]    ${data}
    Open Lead Modal
    Verify Lead Modal Is Open
    Fill Lead Form    
    ...    data=${data}
    Submit Lead Form
    

Failed Attempt To Submit Form
    [Arguments]    ${data}    ${name_alert_text}    ${email_alert_text}

    Open Lead Modal And Submit Form    
    ...    data=${data}
    Verify Lead Form Has Alert Text    
    ...    name_alert_text=${name_alert_text}    
    ...    email_alert_text=${email_alert_text}
    Close Lead Modal
    Verify Lead Modal Is Closed
    


*** Test Cases ***
Should register a lead in wait list 
    [Tags]    smoketest
    Log    ${DATA}[success]
    
    Open Lead Modal And Submit Form    
    ...    data=${DATA}[success]
    Verify Lead Modal Is Closed
    Verify Modal Is Opened
    Verify Modal Success Message    
    ...    title_message=Fila de espera  
    ...    body_message=Agradecemos por compartilhar seus dados conosco. Em breve, nossa equipe entrará em contato.


Should not register a duplicated lead
    ${data}    Set Variable   ${DATA}[fail][duplicated]
    Create Lead    payload=${data}
    Open Lead Modal And Submit Form    data=${data}
    Verify Modal Success Message    
    ...    title_message=!\nAtenção!
    ...    body_message=Verificamos que o endereço de e-mail fornecido já consta em nossa lista de espera. Isso significa que você está um passo mais perto de aproveitar nossos serviços.
     
Should not submit form with invalid data    
    [Template]    Failed Attempt To Submit Form
    data=${DATA}[fail][empty_form]     name_alert_text=Campo obrigatório    email_alert_text=Campo obrigatório
    data=${DATA}[fail][empty_name]     name_alert_text=Campo obrigatório    email_alert_text=${EMPTY}
    data=${DATA}[fail][empty_email]    name_alert_text=${EMPTY}    email_alert_text=Campo obrigatório
    data=${DATA}[fail][invalid]        name_alert_text=${EMPTY}    email_alert_text=Email incorreto
