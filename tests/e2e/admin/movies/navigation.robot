*** Settings ***
Documentation        Admin Movies Page - test suit for Navigation feature
Resource            ../../../../resources/pages/BasePage.resource
Resource            ../../../../resources/pages/AdminMoviesPage.resource
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
*** Test Cases ***
Should open movie registration form
    Click Add Movie Link
    Verify Is URL Page    page_url=admin/movies/register
