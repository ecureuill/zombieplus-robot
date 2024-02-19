*** Settings ***
Documentation       Admin Login Page - test suit for Admin Authentication feature
Resource            ../../../resources/pages/AdminLoginPage.resource
Resource            ../../../resources/pages/AdminMoviesPage.resource
Test Setup          Start Browser Context    page_url=admin/login
Test Teardown       Take Screenshot    fullPage=True

*** Test Cases ***
Should authenticate admin user
    ${data}    Get Fixture    
    ...    file_name=login    
    ...    scenario=success
    Fill Admin Login Form        data=${data}
    Submit Admin Login Form
    Verify Is URL Page           page_url=admin/movies
    Verify User Authenticated    user=${data}[name]
