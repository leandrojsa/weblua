require "http"
require "converter"
util = require "util"
ncluasoap = require "ncluasoap"

callback_func = nil
data_format = nil

function soap_request(url, paramstable, callback, soap_version, port)
    callback_func = callback
    paramstable['address'] = url
    data_format = 'soap'
    ncluasoap.call(paramstable, callback_handler, soap_version, port)
end

function rest_request(url, paramstable, callback, format, method)
    callback_func = callback
    
    if format ~= 'xml' or format ~= 'json' then
        return false
    end
    data_format = format
    
    if method == 'get' then
        url = url .. '?' .. util.urlEncode(paramstable)
        http.request(url, callback_handler, method)
    elseif method == 'post' then
        http.request(url, callback_handler, method, paramstable)
    end   
    
end

function callback_handler(header, body)
    print('\n\n\nentering callback2\n\n\n')
    util.printable(header)
    if data_format == 'xml' then
        print 'REST XML'
    elseif data_format == 'json' then
        print 'REST JSON'
    elseif data_format == 'soap' then
        print 'SOAP XML'
    end
    callback_func(header, body)
end
