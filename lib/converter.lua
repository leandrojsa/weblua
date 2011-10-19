package.path = package.path .. ';lib/LuaXML/?.lua'
package.path = package.path .. ';lib/json4lua/?.lua'

require "xml"
require "handler"
json = require("json")
dofile("lib/LuaXML/xml.lua")
dofile("lib/LuaXML/handler.lua")


function xml_to_table(data)
    local xmlhandler = simpleTreeHandler()
    local xmlparser = xmlParser(xmlhandler)
    xmlparser:parse(data)
    return xmlhandler
end

function soap_xml_to_table(data)
     local xmlhandler = simpleTreeHandler()
     local xmlparser = xmlParser(xmlhandler)
     xmlparser:parse(body, false)
     local xmlTable = {}

     if nsPrefix ~= "" then
        nsPrefix = nsPrefix .. ":"
     end
     
     if xmlhandler and xmlhandler.root then   
        --Se a resposta não possui o Namespace Prefix correspondente
        --à versão do SOAP utilizada, testa outros padrões de prefixo.
        if xmlhandler.root[nsPrefix.."Envelope"] == nil then
          nsPrefix = ""
          local prefixes = {"soap:", "SOAP-ENV:", "soapenv:", "S:", "senv:"}
          for k, v in pairs(prefixes) do
             if xmlhandler.root[v.."Envelope"] ~= nil then
                nsPrefix = v
                break
             end
          end
        end
        print("\n\nResponse nsPrefix = "..nsPrefix.."\n\n")
    
    
        local envelope = nsPrefix.."Envelope"
        local bodytag = nsPrefix.."Body"
        --local operationResp = msgTable.operationName.."Response"
        xmlTable = xmlhandler.root[envelope][bodytag]

        --Dentro da tag body haverá uma outra tag
        --que conterá todos os valores retornados pela
        --função remota. O nome padrão desta tag é 
        --MethodNameResponse (nome do método + Response). 
        --Caso o WS retorne um erro, existirá uma tag Fault dentro
        --do body no lugar da resposta esperada.
        --Assim, o código abaixo pega o valor da primeira chave,
        --que contém os dados da resposta da requisição (seja o retorno
        --do método a tag Fault contendo detalhes do erro)
            
        --O uso da função next não funciona para pegar o primeiro elemento. Trava aqui 
        --_, xmlTable = next(xmlTable)
        for k, v in pairs(xmlTable) do
          xmlTable = v
          break
        end
     end
     
     xmlTable = removeSchema(xmlTable)     
     --xmlTable = util.simplifyTable(xmlTable)
end

function table_to_xml(table)
    print('implement table_to_xml function')
end

function table_to_soap_request(table)
    print('implement table_to_soap_request')
end

function json_to_table(data)
    return json.decode(data)
end

function table_to_json(table)
    return json.encode(table)
end

function table_to_rest_request(table, format)
    if format == 'xml' then
        return table_to_rest_xml_request(table)
    elseif format == 'json' then
        return table_to_rest_json_request(table)
    end
    return nil
end

function table_to_rest_xml_request(table)
    print('implement table_to_rest_xml_request function')
end

function table_to_rest_json_request(table)
    print('implement table_to_rest_json_request function')
end
