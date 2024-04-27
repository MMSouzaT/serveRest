*** Settings ***
Resource    ../resources/base.robot

*** Test Cases ***

Fluxo de validação de autenticação de um usuário cadastrado
    Dado que eu realize a conexão com a API
    Quando eu criar um usuário
    Então devo capturar o Token
    E excluir o usuario

