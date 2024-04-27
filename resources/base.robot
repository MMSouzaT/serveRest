*** Settings ***
Library         RequestsLibrary
Library         JSONLibrary
Library         FakerLibrary
Library         OperatingSystem
Library         String
Library    SeleniumLibrary
Resource        variaveis.robot

*** Keywords ***

Então devo capturar o Token
    ${TOKEN}    Captura Token    ${emailLogin}    ${senhaLogin}
    Set Global Variable    ${TOKEN}

Captura Token
    [Arguments]    ${email}    ${senha}
    ${json_body}    Alterar dados do body de autenticação    ${email}    ${senha}
    ${Headers}    Create Dictionary    content-type=application/json
    ${resposta_auth}    POST On Session    Conexao_API    /login
    ...    json=${json_body}
    ...    headers=${Headers}
    ...    expected_status=200
    Log To Console    Autenticado. 
    RETURN    ${resposta_auth.json()['authorization']}

Dado que eu realize a conexão com a API
    ${Conexao_API}    Conexao API
    Set Global Variable     ${Conexao_API}     ${Conexao_API}

Conexao API
    Create Session    Conexao_API    ${baseURL}
    RETURN    Conexao_API

Alterar dados do body cadastrar usuario
    [Arguments]    ${email}    ${senha}    ${nome}    ${administrador}
    ${body}    Get File    resources/data/cadastrar_usuario.json
    ${body}    Convert To String    ${body}
    
    ${body}     Replace String Using Regexp     ${body}     nomeUsuario         ${nome}
    ${body}     Replace String Using Regexp     ${body}     emailUsuario         ${email}
    ${body}     Replace String Using Regexp     ${body}     senhaUsuario         ${senha}
    ${body}     Replace String Using Regexp     ${body}     administradorInformado         ${administrador}

    ${json_body}    Convert String To Json    ${body}
    RETURN    ${json_body}

Alterar dados do body de autenticação
    [Arguments]    ${email}    ${senha}
    ${body}    Get File    resources/data/login.json
    ${body}    Convert To String    ${body}
    
    ${body}     Replace String Using Regexp     ${body}     emailLogin         ${email}
    ${body}     Replace String Using Regexp     ${body}     senhaLogin         ${senha}

    ${json_body}    Convert String To Json    ${body}
    RETURN    ${json_body}

Quando eu criar um usuário
    ${idUsuarioCriado}    Criar usuario    ${emailLogin}    ${senhaLogin}    ${nome}    true
    Set Global Variable    ${idUsuarioCriado}    ${idUsuarioCriado}
Criar usuario
    [Arguments]    ${email}    ${senha}    ${nome}    ${administrador}
    ${json_body}    Alterar dados do body cadastrar usuario    ${email}    ${senha}    ${nome}    ${administrador}
    ${Headers}    Create Dictionary    content-type=application/json
    ${resposta_criar_usuario}    POST On Session    Conexao_API    /usuarios
    ...    json=${json_body}
    ...    headers=${Headers}
    ...    expected_status=201
    Log To Console    ${resposta_criar_usuario.json()['_id']}
    RETURN    ${resposta_criar_usuario.json()['_id']}

E excluir o usuario
    ${mensagem}    Excluir usuario    ${idUsuarioCriado}
    Log To Console    ${mensagem}
Excluir usuario
    [Arguments]    ${idUsuario}
    ${resposta_delete}    DELETE On Session    Conexao_API    /usuarios/${idUsuario}
    ...    expected_status=200
    
    RETURN    ${resposta_delete.json()['message']}