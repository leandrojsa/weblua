---Aplicação de exemplo que consome Web Service para conversão de moedas.
--@author Manoel Campos da Silva Filho<br>
--<a href="http://manoelcampos.com">http://manoelcampos.com</a>

--Adiciona o diretório lib ao path de bibliotecas, para que a aplicação encontre
--os módulos disponibilizados
package.path = package.path .. ';lib/?.lua'

require "weblua"

local util = require "util"

local weather_info = {}

---Função para processar a resposta da requisição SOAP enviada ao WS
--@param result Resultado da chamada ao método remoto via SOAP.
--No caso deste Web Service, o resultado é uma variável primitiva simples (ou seja, contendo apenas um valor)
local function getResponse(result)
  --Forma de uso com NCLua SOAP anterior a 0.5.6
  --print("\n\n---------Cotação do Dolar em Reais:", result.ConversionRateResult, "\n\n")

  weather_info = result
  print("\n\n\n--------------------------------RESULTADO--------------------------------")
  print("         Cotação do Dolar em Reais:", result)
  print("--------------------------------RESULTADO--------------------------------\n\n\n")


  --Finaliza o script lua. Um link no NCL finalizará a aplicação NCL quando o nó lua for finalizado
  --event.post {class="ncl", type="presentation", action="stop"}
end

local msgTable = {}
 

msgTable = {
  namespace = "http://www.webserviceX.NET",
  operationName = "GetWeather",
  params = {
    CityName = "Salvador",
    CountryName = "Brazil"
  }
}
soap_request("http://www.webservicex.net/globalweather.asmx", msgTable, getResponse)


function handler(evt)


    if (evt.class == 'key' and evt.type == 'press') then        
	    print("key:", evt.key)
	    
	    if evt.key == 'RED' then
	        event.post {class="ncl", type="presentation", action="stop"}
	    end
	    
	    if evt.key == 'YELLOW' then
	        print "======"
	        for k, v in pairs(weather_info) do
	            print(k,v)
	        end
	    end
	    
    end
end

event.register(handler)

