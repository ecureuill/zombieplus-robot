*** Settings ***
Documentation        Header Component - elements and actions
Resource             ./BaseComponent.resource

*** Variables ***
${NAVBAR_HEADER_SELECTOR}         nav
${AUTHENTICATED_USER_SELECTOR}    ${NAVBAR_HEADER_SELECTOR} .logged-user
${LINK_MOVIES_SELECTOR}           ${NAVBAR_HEADER_SELECTOR} a[name=Filmes]
${LINK_TVSHOWS_SELECTOR}          ${NAVBAR_HEADER_SELECTOR} a[name=Séries de TV]
${LINK_LEADS_SELECTOR}            ${NAVBAR_HEADER_SELECTOR} a[name=Séries de TV]
${LINK_EXIT_SELECTOR}             ${NAVBAR_HEADER_SELECTOR} a[name=Sair]

*** Keywords ***
Verify User Authenticated
    [Arguments]    ${user_name}
    Wait For Elements State    selector=${AUTHENTICATED_USER_SELECTOR}

Click Movies Link
    Click    selector=${LINK_MOVIES_SELECTOR}

Click TV SHOWS Link
    Click    selector=${LINK_TVSHOWS_SELECTOR}

Click Leads Link
    Click    selector=${LINK_LEADS_SELECTOR}

Click Exit Link
    Click    selector=${LINK_EXIT_SELECTOR}