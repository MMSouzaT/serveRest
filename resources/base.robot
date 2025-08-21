*** Settings ***
Library         RequestsLibrary
Library         JSONLibrary
Library         FakerLibrary
Library         OperatingSystem
Library         String
Resource        variables.robot

*** Keywords ***

Then Get Token
    ${TOKEN}    Get new Token    ${generatedEmail}    ${password}
    Set Global Variable    ${TOKEN}

Get new Token
    [Arguments]    ${emailReceived}    ${passwordReceived}
    ${json_body}    Change json data    ${emailReceived}    ${passwordReceived}    login
    ${Headers}    Create Dictionary    content-type=application/json
    ${resposta_auth}    POST On Session    API Conection     /login
    ...    json=${json_body}
    ...    headers=${Headers}
    ...    expected_status=200
    Log To Console    Authenticated. 
    RETURN    ${resposta_auth.json()['authorization']}

Given i get the API conection
    ${APIConection}    API Conection 
    Set Global Variable     ${APIConection}     ${APIConection}
    Generate data

API Conection
    Create Session    APIConection    ${baseURL}
    RETURN    APIConection

Generate data
    ${generatedEmail}    FakerLibrary.Email
    Set Global Variable    ${generatedEmail}    ${generatedEmail}
    Log To Console    ${generatedEmail}

    ${generatedName}    FakerLibrary.Name
    Set Global Variable    ${generatedName}    ${generatedName}
    Log To Console    ${generatedName}

Change json data
    [Arguments]    ${email}    ${password}    ${path}    ${name}=default    ${admin}=default    
    ${body}    Get File    resources/data/${path}.json
    ${body}    Convert To String    ${body}
    
    ${body}     Replace String Using Regexp     ${body}     nameUser         ${name}
    ${body}     Replace String Using Regexp     ${body}     emailUser         ${email}
    ${body}     Replace String Using Regexp     ${body}     passwordUser         ${password}
    ${body}     Replace String Using Regexp     ${body}     adminPassed         ${admin}

    ${json_body}    Convert String To Json    ${body}
    RETURN    ${json_body}

When i create a new user
    ${userIdCreated}    Create user    ${generatedEmail}    ${password}    ${generatedName}    true
    Set Global Variable    ${userIdCreated}    ${userIdCreated}
    Log To Console    ID Received: ${userIdCreated}
    
Create user
    [Arguments]    ${emailReceived}    ${passwordReceived}    ${nameReceived}    ${admin}
    ${json_body}    Change json data    ${emailReceived}    ${passwordReceived}    create_user    ${nameReceived}    ${admin}
    ${Headers}    Create Dictionary    content-type=application/json
    ${resposta_criar_usuario}    POST On Session    APIConection    /usuarios
    ...    json=${json_body}
    ...    headers=${Headers}
    ...    expected_status=201
    Log To Console    ${resposta_criar_usuario.json()['_id']}
    RETURN    ${resposta_criar_usuario.json()['_id']}

And exclude user
    ${mensagem}    Delete user    ${userIdCreated}
    Log To Console    ${mensagem}

Delete user
    [Arguments]    ${idReceived}
    ${resposta_delete}    DELETE On Session    APIConection    /usuarios/${idReceived}
    ...    expected_status=200
    
    RETURN    ${resposta_delete.json()['message']}