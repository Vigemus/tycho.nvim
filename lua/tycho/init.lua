-- luacheck: globals unpack vim.api
local nvim = vim.api
local tycho = {
  api = {},
  cache = {}
}

local frosting = {
  __newindex = function(meta, key, value)
    if key == "map" then
      if type(value) == "table" then
        tycho.api.map(meta.ns, unpack(value))
      else
        tycho.api.map(meta.ns, value)
      end
    end
  end
}

local sugar = {
  __newindex = function(_, key, value)
    if key == "api" then
      error("can't overwrite api", 2)
    end

    tycho.api.register(key, value)
  end,

  __index = function(table, key)
    if key == "api" then
      return rawget(table, "api")
    end

    local cache = rawget(table, "cache")
    local ret = {
      ns = key,
      fn = cache[key]
    }
    setmetatable(ret, frosting)
    return ret
  end
}

tycho.api.register = function(namespace, fn)
  local cache = rawget(tycho, "cache")
  rawset(cache, namespace, fn)
end

tycho.api.call = function(namespace, ...)
  local fn = rawget(tycho, "cache")[namespace]
  return fn(...)
end

tycho.api.map = function(namespace, kw, ...)
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

  nvim.nvim_command("map " .. kw .. " <Cmd>lua tycho.api.call(" .. command .. ")<CR>")
end

tycho.api.debug = function()
  print(require("inspect")(tycho.cache))
  end

setmetatable(tycho, sugar)

_G.tycho = tycho
return tycho
