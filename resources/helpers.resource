*** Settings ***
Documentation    Helpers

Library    JSONLibrary

*** Keywords ***
Get Fixture
    [Arguments]    ${file_name}    ${scenario}
    ${data}    Load Json From File    
    ...    ${EXECDIR}/resources/fixtures/data/${file_name}.json    
    ...    encoding=utf-8

    RETURN    ${data}[${scenario}]

Get Json From String
    [Arguments]    ${string}
    ${json}    Evaluate    json.loads(${string})
    RETURN    ${json}