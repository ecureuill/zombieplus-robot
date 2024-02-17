*** Settings ***
Documentation     Home page test suit
Resource          ../../../resources/pages/HomePage.resource

Test Setup        Start Browser Context
Test Teardown     Take Screen Shot    fullPage=True

*** Test Cases ***
Should go to admin page
    Go To Admin