local GenericObjectPool = require 'resty.thrift.GenericObjectPool'
local TestServiceClient = require "resty.thrift.thrift-idl.lua_test_TestService"
local ngx = ngx

local client = GenericObjectPool:connection(TestServiceClient,'127.0.0.1',9090)
local res = client:say('hi')
GenericObjectPool:returnConnection(client)
ngx.say(res)
