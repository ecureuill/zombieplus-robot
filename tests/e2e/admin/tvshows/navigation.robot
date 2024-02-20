*** Settings ***
Documentation        Admin Tv Shows Page - test suit for Navigation feature
Resource            ../../../../resources/pages/BasePage.resource
Resource            ../../../../resources/pages/AdminTvShowsPage.resource
Resource            ../../../../resources/pages/AdminLoginPage.resource
Test Setup          Test Setup
Test Teardown       Take Screenshot    fullPage=True

*** Keywords ***
Test Setup
    ${user}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    
    Start Browser Context    page_url=admin/login
    Autenthicate User    data=${user}
    Verify Is URL Page    page_url=admin/movies
    Go to URL    page_url=admin/tvshows

*** Test Cases ***
Should open movie registration form
    Click Add TV Shows Link
    Verify Is URL Page    page_url=admin/tvshows/register
