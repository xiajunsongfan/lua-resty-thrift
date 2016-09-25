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

	1. create thrift lua client (thrift 0.9.3) 
	   用thrift命令生成thrift客户端
	   :> thrift gen -lua tets.thrift
	2. 将生成的文件拷贝openresty安装目录下的lualib/resty/thrift/thrift-idl/目录，thrift目录自己创建
	   :>cp gen-lua/*_Service.lua /${openresty.path}/lualib/resty/thrift/thrift-idl/  (*_Service.lua test.thrift `service TestService {}`)
	3. :> cp gen-lua/*_ttypes.lua /${openresty.path}/lualib/resty/thrift/thrift-idl/
	4. Replace *_Service.lua *_Service.lua `require`
	   由于thrift生成的文件都是全局变量，而openresty建议使用的是local变量，因此需要把生成的文件变量改掉。
	   *_ttypes.lua:
	   local Thrift = require 'resty.thrift.thrift-lua.Thrift' -- local 方式引入变量
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
	5. 拷贝本项目下的所有so包到/usr/local/lib/ 如果该目录不在系统加载so包的默认设置里，可以手动一下，或者将so包放到/usr/lib/里
	   :> cp lua-resty-thrift/lib/*.so /usr/local/lib/
	6. 添加so包后需要让so包被加载
	   :> ldconfig
	7. 将本项目lib目录下的resty目录拷贝到openresty的安装目录
	   :> cp lib/resty /${openresty.path}/lualib/
	
       

