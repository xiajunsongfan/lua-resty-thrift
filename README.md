Name
===
lua-resty-thrift - Lua thrift client driver for the ngx_lua based on the cosocket API

Synopsis
===

*nginx.conf:*  
```lua

   server {
       location /test{
            content_by_lua '
                local GenericObjectPool = require "resty.thrift.GenericObjectPool"
                local TestServiceClient = require "resty.thrift.thrift-idl.lua_test_TestService"
                local ngx = ngx
                local client = GenericObjectPool:connection(TestServiceClient,'127.0.0.1',9090)
                local res = client:say('thrift')
                GenericObjectPool:returnConnection(client)
                ngx.say(res)
            ';
       }
   
   }
   
```

*thrift:*
```thrift
   namespace java com.test.thrift
   namespace lua lua_test

   service TestService {
      string say(1:string request)
   }
```

	1. create thrift lua cilet (thrift 0.9.3) 
	   :> thrift gen -lua tets.thrift
	2. >cp gen-lua/*_Service.lua /${openresty.path}/lualib/resty/thrift/thrift-idl/  (*_Service.lua test.thrift `service TestService {}`)
	3. :> cp gen-lua/*_ttypes.lua /${openresty.path}/lualib/resty/thrift/thrift-idl/
	4. Replace *_Service.lua *_Service.lua `require`
	   *_ttypes.lua:
	   local Thrift = require 'resty.thrift.thrift-lua.Thrift'
       local TType = Thrift[1]
       local TMessageType = Thrift[2]
       local __TObject = Thrift[3]
       local TException = Thrift[4]
       local TApplicationException = Thrift[5]
       local __TClient = Thrift[6]
       
       *_Service.lua:
       local Thrift = require 'resty.thrift.thrift-lua.Thrift'
       local TType = Thrift[1]
       local TMessageType = Thrift[2]
       local __TObject = Thrift[3]
       local TException = Thrift[4]
       local TApplicationException = Thrift[5]
       local __TClient = Thrift[6]
	5. :> cp lua-resty-thrift/lib/*.so /usr/local/lib/
	6. :> ldconfig
	
       

