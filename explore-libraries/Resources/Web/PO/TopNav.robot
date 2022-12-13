*** Settings ***
Documentation  Amazon top navigation
Library  SeleniumLibrary

*** Keywords ***
Search for Products
    Enter Search Term
    Submit Search

Enter Search Term
    Input Text  id:twotabsearchtextbox  ${SEARCH_TERM}

Submit Search
    Click Button  xpath://input[@id='nav-search-submit-button']