*** Settings ***
Documentation   Main resource file

Library    Browser
Variables   ../env.yaml
Resource    ../helpers.resource
Resource    ../services.resource

*** Keywords ***
Start Browser Context
    [Arguments]    ${page_url}=${EMPTY}
    New Browser    browser=firefox    headless=False 
    New Page       ${FRONT_HOST}/${page_url}

Go to URL
    [Arguments]    ${page_url}=${EMPTY}
    Go To    url=${FRONT_HOST}/${page_url}

Verify Is URL Page
    [Arguments]    ${page_url}=${EMPTY}
    Get Url    equal    ${FRONT_HOST}/${page_url}
