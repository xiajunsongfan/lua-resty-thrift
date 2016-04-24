local Thrift = require 'resty.thrift.thrift-lua.Thrift'
local tcp = ngx.socket.tcp
local __TObject = Thrift[3]
-- TSocket
local TSocket = __TObject:new{
  __type = 'TSocket',
  timeout = 1000,
  host = 'localhost',
  port = 9090,
  handle
}

function TSocket:isOpen()
  if self.handle then
    return true
  end
  return false
end
function TSocket:setTimeout(timeout)
  if timeout and ttype(timeout) == 'number' then
    if self.handle then
      self.handle:settimeout(timeout)
    end
    self.timeout = timeout
  end
end

function TSocket:close()
  if self.handle then
      self.handle:close()
    self.handle = nil
  end
end

function TSocket:open()
  if self.handle then
    self:close()
  end
  local sock = tcp()
  local ok, err = sock:connect(self.host, self.port)
  if ok then
    self.handle = sock
    sock:settimeout(self.timeout)
  end

  if err then
    error("TTransportException: Could not connect to "..self.host .." : "..self.port.."("..err..")")
  end
end

function TSocket:read(len)
  local sock = self.handle
  sock:settimeout(self.readTimeout)
  local buf,err,partial = sock:receive(len)
  if err == 'timeout' then
    error("TTransportException: TIMED_OUT")
  end
  if not buf or string.len(buf) ~= len then
    error("TTransportException: UNKNOWN ip: "..self.host.." port: "..self.port)
  end
  return buf
end

function TSocket:readAll(len)
  local buf, have, chunk = '', 0
  while have < len do
    chunk = self:read(len - have)
    have = have + string.len(chunk)
    buf = buf .. chunk

    if string.len(chunk) == 0 then
      error("TTransportException: end_of_file.")
    end
  end
  return buf
end

function TSocket:write(buf)
  local sock = self.handle
  sock:send(buf)
end

function TSocket:flush()
end
--set socket connection pool
function TSocket:setKeepalive(...)
  local sock = self.handle
  sock:setkeepalive(...)
end
return TSocket
