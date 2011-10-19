package.path = package.path .. ';lib/LuaXML/?.lua'

require "xml"
require "handler"

package.path = package.path .. ';lib/json4lua/?.lua'

json = require('json')


function xml_to_table(data)
    local xmlhandler = simpleTreeHandler()
    local xmlparser = xmlParser(xmlhandler)
    xmlparser:parse(data)
    return(xmlhandler)    
end

function table_to_xml(table)
    print('implement table_to_xml function')
end

function table_to_soap_request(table)
    print('implement table_to_soap_request')
end

function json_to_table(data)
    print('implement json_to_table function')
    return(json.decode(data))
end

function table_to_json(table)
    print('implement table_to_json function')
    return(json.encode(table))
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


--TODO: remover isso daqui, usar util
---Função para converter uma string para o formato URL-Encode,
--também chamado de Percent Encode, segundo RFC 3986.
--Fonte: http://www.lua.org/pil/20.3.html
--@param s String a ser codificada
--@returns Returna a string codificada
function escape (s)
  s = string.gsub(s, "([&=+%c])", function (c)
        return string.format("%%%02X", string.byte(c))
      end)
  s = string.gsub(s, " ", "+")
  return s
end
