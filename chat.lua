local pretty = require('cc.pretty')

local args = { ... }

-- Config
local rednetModemLocation = "right"
local rednetProtocol = 'cow.chat'
local rednetHostname = 'cow.port.%d'
local port = 1000

local connections = {}

function allmatching(tbl, kvs)
  return function(t, key)
    repeat
      key, row = next(t, key)

      if key == nil then
        return
      end

      for k, v in pairs(kvs) do
        if row[k] ~= v then
          row = nil
          break
        end
      end
    until row ~= nil

    return key, row
  end, tbl, nil
end

function in_table(tbl, data)
  for k, con in allmatching(tbl, data) do
    return true
  end

  return false
end

function host_server(port)
  rednet.host(rednetProtocol, string.format(rednetHostname, port))

  while true do
    num, data, protocol = rednet.receive(rednetProtocol)

    pretty.print(pretty.pretty(data))

    if not in_table(connections, data['source']) then
      print(string.format('Establishing connection with computer #%d', data['source']['id']))
      table.insert(connections, data['source'])
    end
  end
end

function connect_to_server(port, name)
  rednet.broadcast({
    source = {
      id = os.getComputerID(),
      name = name
    }
  }, rednetProtocol)
end

function start_loop()
  while true do
    message = get_message()

    rednet.broadcast({
      source = {
        id = os.getComputerID(),
        name = name
      },
      message = message
    }, rednetProtocol)
  end
end

function get_message()
  write("> ")
  return read()
end

function print_help()
  print("usage: chat host [port]")
  print("usage: chat join [port] [name]")
end

rednet.open(rednetModemLocation)

if #args == 2 and args[1] == "host" then
    print("hosting " .. args[2])
    host_server(args[2])
elseif #args == 3 and args[1] == "join" then
  print("joining " .. args[2])
  connect_to_server(args[2], args[3])
  start_loop(args[2], args[3])
else
  print_help()
end
