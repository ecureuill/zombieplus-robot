*** Settings ***
Documentation   Main resource file

Library    Browser
Variables   ../env.yaml
Resource    ../helpers.resource
Resource    ../services.resource

*** Keywords ***
Start Browser Context
    [Arguments]    ${page_url}=${FRONT_HOST}
    New Browser    browser=firefox    headless=False 
    New Page       ${page_url}