-- luacheck: globals unpack vim.api
local nvim = vim.api
local tycho = {
  core = {},
  api = {},
  cache = {}
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

tycho.core.register = function(namespace, fn)
  local cache = rawget(tycho, "cache")
  rawset(cache, namespace, fn)
end

tycho.core.call = function(namespace, ...)
  local fn = rawget(tycho, "cache")[namespace]
  return fn(...)
end

tycho.core.map = function(namespace, kw, ...)
  local args = {...}
  local command = "'" .. namespace .. "'"
  if #args >= 0 then
    for _, i in ipairs(args) do
      if type(i) == "string" then
        command = command .. ", '" .. i .. "'"
      else
        command = command .. ", " .. i
      end
    end
  end

  nvim.nvim_command("map " .. kw .. " <Cmd>lua tycho.core.call(" .. command .. ")<CR>")
end

tycho.core.debug = function()
  print(require("inspect")(tycho))
end

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

setmetatable(tycho, sugar)

_G.tycho = tycho
return tycho
