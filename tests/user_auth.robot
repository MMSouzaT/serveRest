*** Settings ***
Resource    ../resources/base.robot

*** Test Cases ***

Authentication validation flow for a registered user
    Given i get the API conection
    When i create a new user
    Then Get Token
    And exclude user

