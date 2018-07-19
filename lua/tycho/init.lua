-- luacheck: globals unpack vim.api
local nvim = vim.api
local impl = require("tycho.core")
local tycho = {
  api = {},
  core = impl.core,
  cache = impl.cache
}

local sugar = {
  __newindex = function(_, key, value)
    tycho.core.register(key, value)
  end,

  __index = function(table, key)
    local real = rawget(table, key)
    if real ~= nil then
      return real
    end

    local cache = rawget(table, "cache")
    local ret = {
      ns = key,
      fn = cache[key]
    }
    return ret
  end
}

tycho.api.map = function(keymap, fn)
  local func
  local ns

  if type(fn) == "table" then
    ns = fn.ns
    func = fn.fn
  else
    ns = tostring(math.random(1, 9999999))
    func = fn
  end

  tycho.core.register(ns, func)
  tycho.core.map(ns, keymap)
end

tycho.api.debug = function()
  print(require("inspect")(tycho))
end

setmetatable(tycho, sugar)

_G.tycho = tycho
return tycho
