package.path = package.path .. ';lib/?.lua'

require "weblua"
util = require "util"

local itemIndex = -1
local tweets = nil

---Escreve um texto na parte inferior da área do canvas lua
--@param text Texto a ser escrito
function writeText(text)
   canvas:attrColor(255, 255, 255, 0)
   canvas:clear();
   
   local cw, ch = canvas:attrSize()
   
   canvas:attrFont("vera", 24)
   local tw, th = canvas:measureText("A")
   canvas:drawText(5, ch-th, text)
   canvas:flush()
end

function breakString(str, maxLineSize)
  local t = {}
  local i, fim, countLns = 1, 0, 0

  if (str == nil) or (str == "") then
     return t
  end 

  str = string.gsub(str, "\n", " ")
  str = string.gsub(str, "\r", " ")
    
  while i < #str do
     countLns = countLns + 1
     if i > #str then
        t[countLns] = str
        i = #str 
     else
        fim = i+maxLineSize-1
        if fim > #str then
           fim = #str
        else
	        --se o caracter onde a string deve ser quebrada
	        --não for um espaço, procura o próximo espaço
	        if string.byte(str, fim) ~= 32 then
	           fim = string.find(str, ' ', fim)
	           if fim == nil then
	              fim = #str
	           end
	        end
        end
        t[countLns]=string.sub(str, i, fim)
        i=fim+1
     end
  end
  
  return t
end

function showItem()
    if (itemIndex < 0)  or (#tweets  == 0) then 
        return
    end
    local i = itemIndex
    title = tweets[i].text
    local cw, ch = canvas:attrSize()
      
    canvas:attrColor(255, 255, 255, 255)
    canvas:attrColor("white")
    canvas:drawRect("fill", 0, 0, cw, ch)
      
    canvas:attrColor("blue")
    canvas:attrFont("vera", 24)
    local cat = tweets[i].created_at or ""
    cat = cat .. '  (' .. itemIndex ..' de '.. #tweets ..')'
    canvas:drawText(5, 0, cat)
    
    canvas:attrColor("black")
    canvas:attrFont("vera", 22)
 
    local tw, th = canvas:measureText("a")
    local charsByLine = tonumber(string.format("%d", cw / tw))
      
    local desc = title
    local desctb = breakString(desc, charsByLine)
    local y = 30

    for k,ln in pairs(desctb) do
        canvas:drawText(5, y, ln)
        y = y + th + 4
    end
    
    local imgAtualizar = canvas:new("media/atualizar.png")
    local imw, imh = imgAtualizar:attrSize()
    canvas:compose(cw-2*imw, ch-imh, imgAtualizar)
    
    local imgFechar = canvas:new("media/fechar.png")
    local imw, imh = imgFechar:attrSize()
    canvas:compose(cw-imw, ch-imh, imgFechar)

    local imgEsq = canvas:new("media/esq.png")
    local imw, imh = imgEsq:attrSize()
    canvas:compose(cw-imw*2, 0, imgEsq)
    local imgDir = canvas:new("media/dir.png")
    canvas:compose(cw-imw, 0, imgDir)
    
    canvas:flush()
end

function callback(table)
    print 'callback'
    tweets = table
    itemIndex = 1
    showItem()

--    print('response_table:', table)
--    for k, v in pairs(table) do
--        print(k,":", v)
--        for i, j in pairs(v) do
--            print('--->', i,":", j)
--        end
--    end
end

--[[
function callback(header, body)
    if body then
        xmlhandler = xml_to_table(body)
        for i=1,5,1 do
            print("\tTweet: ", xmlhandler.root.rss.channel.item[i].title)
            print("\tData de Publicação: ", xmlhandler.root.rss.channel.item[i].pubDate)
        end
        
        if xmlhandler.root.rss == nil then
	        canvas:clear()
	        canvas:flush()
	        return
	    end
	  
	    print("Total de itens:\t", #xmlhandler.root.rss.channel.item)
	    itemIndex = 1
	    showItem()	
    end 
end
]]

---Retorna um novo índice de notícia a ser exibida.
--@param index Valor do índice da notícia atualmente exibida
--@param forward Se igual a true, incrementa o índice em 1,
--senão, decrementa em 1.
--@returns Retorna o novo índice da notícia a ser exibida.
function moveItemIndex(index, forward)
  --Se o index for menor que zero, é porque
  --o XML do feed ainda não foi baixado, logo,
  --não há notícia a ser exibida.
  if index < 0 then
     return index
  end
  
  if forward then
  	 index = index + 1
  	 if index > #tweets then
  	    index = 1
  	 end
  else
  	 index = index - 1
  	 if index <= 0 then
  	    index = #tweets
  	 end
  end
  return index
end 


local flag = false

function handler(evt)

    if flag ~= true then
        writeText("Buscando tweets...")

        local paramstable = {
            screen_name='leojsandrade',
        }
        
        rest_request("http://api.twitter.com/1/statuses/user_timeline.json", paramstable, callback, 'json', 'get')
    
        writeText("")
        flag = true
    end      

    if (evt.class == 'key' and evt.type == 'press') then        
	    print("key:", evt.key)
	    local ok = false
	    if evt.key == 'BLUE' then

             writeText("Buscando tweets...")
             
             local paramstable = {
               screen_name='leojsandrade',
            }
             rest_request("http://api.twitter.com/1/statuses/user_timeline.json", paramstable, callback, 'json', 'get')
        end
        if evt.key == "CURSOR_RIGHT" then
	        ok = true
	        itemIndex = moveItemIndex(itemIndex, true)
	    elseif evt.key == "CURSOR_LEFT" then
	        ok = true
	        itemIndex = moveItemIndex(itemIndex, false)
	    end
	  
	    if ok then
	        showItem()
	    end
    end
end

event.register(handler)
